import pymysql
import bcrypt
import datetime  # Include datetime for current date
from flask import jsonify
from dash import Dash
from dash import dcc, html
from flask import Flask, render_template, request, redirect, url_for, flash, session



app = Flask(__name__)
app.secret_key = 'scoobydoobydoo'  # Set a secret key for flashing messages

# Database connection info
db_connection_info = {
    'host': 'localhost',
    'user': 'root',
    'password': '00000000',
    'db': 'Medical_equipment_system'
}

def get_db_connection():
    return pymysql.connect(**db_connection_info)

def get_location_data(db_connection):
    location_data = {'cities': [], 'states': [], 'countries': []}
    with db_connection.cursor() as cursor:
        cursor.execute("SELECT country_id, country_name FROM Country")
        location_data['countries'] = cursor.fetchall()
        cursor.execute("SELECT state_id, state_name FROM State")
        location_data['states'] = cursor.fetchall()
        cursor.execute("SELECT city_id, city_name FROM City")
        location_data['cities'] = cursor.fetchall()
    return location_data

def get_customer_types(db_connection):
    with db_connection.cursor() as cursor:
        cursor.execute("SELECT customertype_id, customertype_name FROM CustomerType")
        return cursor.fetchall()

@app.route('/')
def index():
    return render_template('welcome.html')


@app.route('/login', methods=['POST', 'GET'])

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        plaintext_password = request.form.get('password')

        db_connection = get_db_connection()
        try:
            with db_connection.cursor() as cursor:
                sql = """
                    SELECT c.customer_id, l.email, l.password 
                    FROM Login l
                    JOIN Customer c ON l.email = c.email
                    WHERE l.email = %s
                """
                cursor.execute(sql, (email,))
                result = cursor.fetchone()

                # Check if result exists and compare the password
                if result and bcrypt.checkpw(plaintext_password.encode('utf-8'), result[2].encode('utf-8')):
                    session['email'] = email
                    session['customer_id'] = result[0]  # Using tuple index for customer_id
                    flash('Login successful!', 'success')
                    return redirect(url_for('customer_page'))
                else:
                    flash('Invalid credentials. Please try again.', 'error')
        except Exception as e:
            flash('Invalid credentials. Please try again.', 'login-error')
            return render_template('login.html')
        finally:
            db_connection.close()

    return render_template('login.html')



@app.route('/place_order', methods=['POST'])
def place_order():
    # Assume we have customer_id from the session
    customer_id = session.get('customer_id')
    supplier_id = request.form.get('supplier_id')
    equipment_id = request.form.get('equipment_id')
    quantity = request.form.get('quantity')
    order_date = datetime.datetime.now().strftime('%Y-%m-%d')  # current date


    db_connection = get_db_connection()
    try:
        with db_connection.cursor() as cursor:
            cursor.callproc('up_write_order', [supplier_id, equipment_id, 'Test Order New', order_date, customer_id, 1,
                                               quantity])  # Replace 1 with actual ordertype_id
            db_connection.commit()
            flash('Order placed successfully!', 'success')
    except Exception as e:
        print(f"An error occurred: {e}")
        db_connection.rollback()
        error_message = 'Failed to place order.'
        flash(error_message, 'error')
        return redirect(url_for('customer_page', error_message=error_message))

    finally:
        db_connection.close()

    return redirect(url_for('customer_page'))



@app.route('/get_equipment_id', methods=['POST'])
def get_equipment_id():
    equipment_name = request.form.get('equipment_name')
    db_connection = get_db_connection()
    try:
        with db_connection.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute("SELECT equipment_id FROM Equipment WHERE equipment_name = %s", (equipment_name,))
            result = cursor.fetchone()
            if result:
                return jsonify({'equipment_id': result['equipment_id']})
            else:
                return jsonify({'error': 'Equipment not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        db_connection.close()


@app.route('/customer_page')
def customer_page():
    error_message = request.args.get('error_message')
    # Clear login-related error messages from the session
    flash_messages = dict(session.get('_flashes', []))
    login_error_messages = flash_messages.get('login-error', [])
    for message in login_error_messages:
        flash(message, 'login-error')

    if 'email' in session:
        email = session['email']

        db_connection = get_db_connection()

        customer_id = None
        customer_name = ''
        customer_city_id = None
        orders = []
        equipments = []
        suppliers = []  # Initialize suppliers

        try:
            with db_connection.cursor(pymysql.cursors.DictCursor) as cursor:
                cursor.execute("SELECT customer_id, customer_name, city_id FROM Customer WHERE email = %s", (email,))
                customer_data = cursor.fetchone()

                if customer_data:
                    customer_id = customer_data['customer_id']
                    customer_name = customer_data['customer_name']
                    customer_city_id = customer_data['city_id']

                    cursor.callproc('up_read_equipment')
                    equipments = cursor.fetchall()

                    # Fetch suppliers

                    cursor.callproc('up_read_supplier_by_equipment', (customer_city_id,))
                    suppliers = cursor.fetchall()

                    cursor.execute("""
                        SELECT order_id, supplier_name, equipment_name, order_name, order_date, quantity
                        FROM Orders
                        INNER JOIN Supplier ON Supplier.supplier_id = Orders.supplier_id
                        INNER JOIN Equipment ON Orders.equipment_id = Equipment.equipment_id
                        WHERE customer_id = %s
                    """, (customer_id,))
                    orders = cursor.fetchall()

        finally:
            db_connection.close()

        return render_template('customer_page.html', equipments=equipments, orders=orders, suppliers=suppliers,
                               customer_id=customer_id, customer_city_id=customer_city_id,
                               customer_name=customer_name, error_message=error_message)

    else:
        flash('Please log in to access this page.', 'error')
        return redirect(url_for('login'))



@app.route('/get_suppliers')
def get_suppliers():
    equipment_id = request.args.get('equipment_id')
    customer_id = request.args.get('customer_id')
    db_connection = get_db_connection()
    suppliers = []
    try:
        with db_connection.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.callproc('up_read_supplier_by_equipment', [equipment_id, customer_id])
            suppliers = cursor.fetchall()
    finally:
        db_connection.close()

    return jsonify(suppliers)

@app.route('/update_order', methods=['POST'])
def update_order():
    try:
        order_id = int(request.form.get('order_id'))
        new_quantity = int(request.form.get('quantity'))
    except (ValueError, TypeError):
        flash('Invalid input. Please enter valid order ID and quantity.', 'error')
        return redirect(url_for('customer_page'))

    db_connection = get_db_connection()
    try:
        with db_connection.cursor() as cursor:
            cursor.callproc('up_update_order', [order_id, new_quantity])
            db_connection.commit()
            flash('Order updated successfully!', 'success')
    except Exception as e:
        db_connection.rollback()
        flash(f'Failed to update order: {e}', 'error')
    finally:
        db_connection.close()
    return redirect(url_for('customer_page'))


# Delete Order Route
@app.route('/delete_order', methods=['POST'])
def delete_order():
    try:
        order_id = int(request.form.get('order_id'))
    except (ValueError, TypeError):
        flash('Invalid order ID. Please enter a valid number.', 'error')
        return redirect(url_for('customer_page'))

    db_connection = get_db_connection()
    try:
        with db_connection.cursor() as cursor:
            cursor.callproc('up_delete_order', [order_id])
            db_connection.commit()
            flash('Order deleted successfully!', 'success')
    except Exception as e:
        db_connection.rollback()
        flash(f'Failed to delete order: {e}', 'error')
    finally:
        db_connection.close()
    return redirect(url_for('customer_page'))


@app.route('/register', methods=['GET', 'POST'])
def register():
    db_connection = get_db_connection()
    location_data = get_location_data(db_connection)
    customer_types = get_customer_types(db_connection)

    if request.method == 'POST':
        customer_name = request.form.get('customer_name')
        address1 = request.form.get('address1')
        address2 = request.form.get('address2')
        address3 = request.form.get('address3')
        zipcode = request.form.get('zipcode')
        email = request.form.get('email')
        city_id = request.form.get('city_id')
        customertype_id = request.form.get('customertype_id')
        password = request.form.get('password').encode('utf-8')
        hashed_password = bcrypt.hashpw(password, bcrypt.gensalt())

        try:
            with db_connection.cursor() as cursor:
                # Insert into Customer table
                sql_customer = """INSERT INTO Customer (customer_name, address1, address2, 
                                 address3, zipcode, city_id, customertype_id, email) 
                                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
                cursor.execute(sql_customer, (customer_name, address1, address2,
                                              address3, zipcode, city_id, customertype_id, email))

                # Insert into Login table
                sql_login = "INSERT INTO Login (email, password) VALUES (%s, %s)"
                cursor.execute(sql_login, (email, hashed_password))

            db_connection.commit()
            flash('Registration successful!', 'success')
        except Exception as e:
            print(f"An error occurred: {e}")
            db_connection.rollback()
            flash('Registration failed. Please try again.', 'error')
        finally:
            db_connection.close()
    return render_template('register.html', location_data=location_data, customer_types=customer_types)



@app.route('/analytics')
def analytics():
    return redirect('http://127.0.0.1:8050/')


if __name__ == '__main__':
    app.run(debug=True, port=5001)
