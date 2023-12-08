
import pandas as pd
import pymysql
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import calendar
import plotly.express as px
from plotly.subplots import make_subplots
import plotly.figure_factory as ff
import plotly.offline as offline
import plotly.graph_objs as go
#offline.init_notebook_mode(connected=True)
import dash
from dash import dcc, html
# from mysql.connector import connect, Error
# from getpass import getpass
from datetime import datetime
from sqlalchemy import create_engine


engine = create_engine("mysql+pymysql://root:00000000@localhost/Medical_equipment_system")

query_no_of_supplier = "SELECT CountDistinctSuppliers() AS distinct_supplier_count;"
query_no_of_state = "SELECT CountDistinctStates() AS distinct_states_count;"
query_no_of_equipment = "SELECT CountDistinctEquipments() AS distinct_equipment_count;"

no_of_supplier = pd.read_sql(query_no_of_supplier, engine)
no_of_state = pd.read_sql(query_no_of_state, engine)
no_of_equipment = pd.read_sql(query_no_of_equipment, engine)

supplier_num = no_of_supplier.at[0, 'distinct_supplier_count']
state_num = no_of_state.at[0, 'distinct_states_count']
equipment_num = no_of_equipment.at[0, 'distinct_equipment_count']

current_date = datetime.now().date()
date_string = current_date.strftime("%Y-%m-%d")

fig0 = go.Figure()
fig0.add_trace(go.Scatter(
    x=[0.5, 2.8, 5.5],
    y=[1.7, 1.7, 1.7, 1.7, 1.7, 1.7],
    mode="text",
    text=["Supplier", "States", "Equipment"],
    textposition="bottom center"
))
fig0.add_trace(go.Scatter(
    x=[0.5, 2.8, 5.5],
    y=[1.1, 1.1, 1.1],
    mode="text",
    text=["<span style='font-size:24px'><b>" + str(supplier_num) + "</b></span>",
          "<span style='font-size:24px'><b>" + str(state_num) + "</b></span>",
          "<span style='font-size:24px'><b>" + str(equipment_num) + "</b></span>"],
    textposition="bottom center"
))
fig0.add_hline(y=2.2, line_width=5, line_color='#60714E')
fig0.add_hline(y=0.3, line_width=3, line_color='#60714E')
fig0.add_trace(go.Scatter(
    x=[2.5],
    y=[-0.2],
    mode="text",
    # text=["<span style='font-size:18px'><b>The data is till following date " + date_string +"</b></span>"],
    textposition="bottom center"
))

fig0.update_yaxes(visible=False)
fig0.update_xaxes(visible=False)
fig0.update_layout(showlegend=False, height=300, #width=1450,
                   title='Medical Equipment Sales Summary', title_x=0.5, title_y=0.9,
                   xaxis_range=[-0.5, 6.6], yaxis_range=[-1.2, 2.2],
                   plot_bgcolor='#fafafa', paper_bgcolor='#fafafa',
                   font=dict(size=20, color='#323232'),
                   title_font=dict(size=32, color='#222'),
                   margin=dict(t=90, l=70, b=0, r=70),
                   )

# ## Top 10 Best Selling Equipment
colors = {}
def colorFader(c1, c2, mix=0):
    c1 = np.array(mpl.colors.to_rgb(c1))
    c2 = np.array(mpl.colors.to_rgb(c2))
    return mpl.colors.to_hex((1 - mix) * c1 + mix * c2)


c1 = '#60714E'
c2 = '#838E73'
n = 9
for x in range(n + 1):
    colors['level' + str(n - x + 1)] = colorFader(c1, c2, x / n)
colors['background'] = '#232425'
colors['text'] = '#fff'


query_best_selling_overall = "SELECT * FROM best_selling_product_overall;"
df_best_selling_overall = pd.read_sql(query_best_selling_overall, engine)

df_best_selling_overall['color'] = colors['level10']
df_best_selling_overall['color'][:1] = colors['level1']
df_best_selling_overall['color'][1:2] = colors['level2']
df_best_selling_overall['color'][2:3] = colors['level3']
df_best_selling_overall['color'][3:4] = colors['level4']
df_best_selling_overall['color'][4:5] = colors['level5']

fig1 = go.Figure(data=[go.Bar(x=df_best_selling_overall['total_orders'],
                              y=df_best_selling_overall['equipment_name'],
                              marker=dict(color=df_best_selling_overall['color']),
                              name='equipment_name', orientation='h',
                              text=df_best_selling_overall['total_orders'].astype(int),
                              textposition='auto',
                              hoverinfo='text',
                              hovertext=
                              '<b>Equipment</b>:' + df_best_selling_overall['equipment_name'] + '<br>' +
                              '<b>Sales</b>:' + df_best_selling_overall['total_orders'].astype(int).astype(
                                  str) + '<br>',
                              # hovertemplate='Family: %{y}'+'<br>Sales: $%{x:.0f}'
                              )])
fig1.update_layout(title_text='The 10 Best-Selling Equipments ', paper_bgcolor=colors['background'],
                   plot_bgcolor=colors['background'],
                   font=dict(
                       size=14,
                       color='white'
                   ))
fig1.update_layout(
    xaxis_title="Number of Orders", yaxis_title="Equipment Name"
)

fig1.update_yaxes(showgrid=False, categoryorder='total ascending')
fig1.update_xaxes(showgrid=False)

# ## Average Sales State wise


query_state_wise_average_sales = "SELECT * FROM average_sales_state_wise;"

df_state_wise_average_sales = pd.read_sql(query_state_wise_average_sales, engine)

# df_city_sa = df_train1.groupby('city').agg({"sales" : "mean"}).reset_index().sort_values(by='sales', ascending=False)
df_state_wise_average_sales['color'] = colors['level10']
df_state_wise_average_sales['color'][:1] = colors['level1']
df_state_wise_average_sales['color'][1:2] = colors['level2']
df_state_wise_average_sales['color'][2:3] = colors['level3']
df_state_wise_average_sales['color'][3:4] = colors['level4']
df_state_wise_average_sales['color'][4:5] = colors['level5']

fig2 = go.Figure(data=[go.Bar(y=df_state_wise_average_sales['average_sales'],
                              x=df_state_wise_average_sales['state_name'],
                              marker=dict(color=df_state_wise_average_sales['color']),
                              name='State',
                              text=df_state_wise_average_sales['average_sales'].astype(int),
                              textposition='auto',
                              hoverinfo='text',
                              hovertext=
                              '<b>State</b>:' + df_state_wise_average_sales['state_name'] + '<br>' +
                              '<b>Sales</b>:' + df_state_wise_average_sales['average_sales'].astype(int).astype(
                                  str) + '<br>',
                              # hovertemplate='Family: %{y}'+'<br>Sales: $%{x:.0f}'
                              )])
fig2.update_layout(title_text='The Average Sales Vs States', paper_bgcolor=colors['background'],
                   plot_bgcolor=colors['background'],
                   font=dict(
                       size=14,
                       color='white'))
fig2.update_layout(
    xaxis_title="State Name", yaxis_title="Sales in USD"
)

fig2.update_yaxes(showgrid=False, categoryorder='total ascending')

# ## Average Sales Vs Date
query_date_wise_average_sales = "SELECT * FROM average_sales_order_date;"

df_date_wise_average_sales = pd.read_sql(query_date_wise_average_sales, engine)


# df_day_sa = df_train1.groupby('date').agg({"sales" : "mean"}).reset_index()
fig3 = go.Figure(data=[
    go.Scatter(x=df_date_wise_average_sales['order_date'], y=df_date_wise_average_sales['average_sales'],
               fill='tozeroy', fillcolor='#838E73', line_color='#60714E')])
fig3.update_layout(title_text='The Average Daily Sales', height=300, paper_bgcolor='#232425', plot_bgcolor='#232425',
                   font=dict(
                       size=12,
                       color='white'))
fig3.update_layout(
    xaxis_title="Date", yaxis_title="Sales in USD"
)
fig3.update_xaxes(showgrid=False)
fig3.update_yaxes(showgrid=False)

# ## Building Dash app to layout all graphs on single page

app = dash.Dash()

app.layout = html.Div([
    html.Div([
        dcc.Graph(
            id='figure1',
            figure=fig0
        ),
    ], style={'width': '100%', 'display': 'inline-block'}),

    html.Div([
        dcc.Graph(
            id='figure2',
            figure=fig1
        ),
    ], style={'width': '50%', 'display': 'inline-block'}),

    html.Div([
        dcc.Graph(
            id='figure3',
            figure=fig2
        ),

    ], style={'width': '50%', 'display': 'inline-block'}),

    html.Div([
        dcc.Graph(
            id='figure4',
            figure=fig3
        ),

    ], style={'width': '100%', 'display': 'inline-block'})
])

if __name__ == '__main__':
    app.run_server()

engine.commit()
engine.close()





