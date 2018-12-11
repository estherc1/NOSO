import dash
from dash.dependencies import Input, Output
import dash_core_components as dcc
import dash_html_components as html
import dash_table_experiments as dt
import pandas as pd
import flask
import plotly.plotly as py
from plotly import graph_objs as go
import math
from lifetimes import BetaGeoFitter

df = pd.read_csv(
    'https://gist.githubusercontent.com/lksfr/c65d53e66ef45673ce4c8f5ef23e2645/raw/c3dc295facb571959dccc917797158b81d032ac2/CLV.csv',
    index_col=False)

df = df.drop("Unnamed: 0", axis=1)

summary2 = pd.read_csv('https://gist.githubusercontent.com/lksfr/cc8488828a89419a50c0486f94f6092a/raw/9c8dfbd080d3a5eaf2b02eab4053c3915156e965/summary2.csv'
    ,index_col='Shipping Company')

#####data for recommendation system#####
usjh_AR = pd.read_csv(
    'https://gist.githubusercontent.com/JialanZ/7143ed3673ab585a23552d4916e2fd45/raw/fd1e5797e4938fc5bc5b4ce3d5edd048a21a598f/usjh_item_flask.csv',
    index_col=False)
rules_ = pd.read_csv(
    'https://gist.githubusercontent.com/JialanZ/7143ed3673ab585a23552d4916e2fd45/raw/fd1e5797e4938fc5bc5b4ce3d5edd048a21a598f/rule_support_flask.csv',
    index_col=False)
rulec_ = pd.read_csv(
    'https://gist.githubusercontent.com/JialanZ/7143ed3673ab585a23552d4916e2fd45/raw/fd1e5797e4938fc5bc5b4ce3d5edd048a21a598f/rule_confidence_flask.csv',
    index_col=False)
###################

bgf = BetaGeoFitter()
bgf.load_model('bgf.pkl')

app = dash.Dash()

app.layout = html.Div([
        # header
        html.Div([
            html.Div(
                html.Img(src='https://i.ibb.co/G74pSt4/transparant.png',height="100%")
                ,style={"float":"left","height":"100%", "margin-top": "0px"})
            ],
            className="row header",style={"background-color": "#ffffff"}
            ),

        # tabs
        html.Div([
            dcc.Tabs(id="tabs", children=[
                html.Div([
                dcc.Tab(label='Customer Lifetime Value', 
                        style={"height":"70px"},
                        children=[
                        #styling
                        html.Link(href="https://use.fontawesome.com/releases/v5.2.0/css/all.css",rel="stylesheet"),
                        html.Link(href="https://cdn.rawgit.com/plotly/dash-app-stylesheets/2d266c578d2a6e8850ebce48fdb52759b2aef506/stylesheet-oil-and-gas.css",rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Dosis", rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Open+Sans", rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Ubuntu", rel="stylesheet"),
                        html.Link(href="https://cdn.rawgit.com/amadoukane96/8a8cfdac5d2cecad866952c52a70a50e/raw/cd5a9bf0b30856f4fc7e3812162c74bfc0ebe011/dash_crm.css", rel="stylesheet"),


                        html.Div([
                            html.H3("Customer Return Probability"),

                            dcc.Dropdown(
                                id='customer_prob',
                                options=[
                                {'label': i, 'value': i} for i in df.ID.unique()
                             ],
                            placeholder='Select customer...'
                         ),

                      #   html.P(style={"margin-top": "17px"}),
                      #  html.P(),

                        
                        dcc.Slider(
                            id='slider',
                            min=0,
                            max=12,
                            marks={i: 'Month {}'.format(i) if i == 1 else str(i) for i in range(1, 13)},
                            value=5,

                    )
                        ,
                html.Br(),
                html.Br(),

                html.Div(id='result', style={"width": "95%"})


                ]

                ,style={"float":"right", "margin-top": "20px", "background-color": "white", "margin-right": "5%", "height": "290px", "width": "40%", "padding-right": "20px", "padding-left": "20px", "border-radius": "25px",
                "border": "2px solid #4286f4" }
                ),




                    html.Div([

                        html.H3("Customer Lifetime Value", style={"padding-left": "150px"}),

                        html.Div([
                        dcc.Dropdown(id='dropdown', style={'width': '60%', "padding-left": "150px"}, options=[
                            {'label': i, 'value': i} for i in df.ID.unique()
                            ], multi=True, placeholder='Filter by customer name...')
                        ], style={'width': '600px'}),
                        html.Br(),

                        html.Div([
                        dcc.Dropdown(id='dropdown2', style={'width': '60%', "padding-left": "150px"}, options=[
                            {'label': i, 'value': i} for i in df.Target_Group.unique()
                            ], multi=True, placeholder='Filter by target group...')

                        ], style={'width': '600px'}),
                        html.Div([

                            dt.DataTable(
                            # Initialise the rows
                            rows=df.to_dict("records"),
                            row_selectable=True,
                            filterable=True,
                            sortable=True,
                            selected_row_indices=[],
                            id='table'
                        )                            
                        ], style = {'width':'95%', 'margin-top': '15px', 'margin-left': '15px', 'margin-bottom': '20px'})
                        ],style={"float":"left", "background-color": "white", "background-color": "white", "margin-left": "5%", "padding-left": "-10px" , "width": "40%", "left": "-10px", "border-radius": "25px",
                        "border": "2px solid #4286f4", "margin-top": "20px"}
                    )

                ])
                ]),

                dcc.Tab(label='Recommendation', 
                        style={"height":"20","verticalAlign":"middle", "text-align": "center"},
                        children=[
                    html.Div([
                        html.Link(href="https://use.fontawesome.com/releases/v5.2.0/css/all.css",rel="stylesheet"),
                        html.Link(href="https://cdn.rawgit.com/plotly/dash-app-stylesheets/2d266c578d2a6e8850ebce48fdb52759b2aef506/stylesheet-oil-and-gas.css",rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Dosis", rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Open+Sans", rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Ubuntu", rel="stylesheet"),
                        html.Link(href="https://cdn.rawgit.com/amadoukane96/8a8cfdac5d2cecad866952c52a70a50e/raw/cd5a9bf0b30856f4fc7e3812162c74bfc0ebe011/dash_crm.css", rel="stylesheet"),

                        html.H3("Some CLV Analysis"),
                        ###########
                        html.H1(children='US Jewerly House Dashboard - Basket Analysis by Line Item'),


                        html.Label('Item(s) on Sale!'),
                        dcc.Dropdown(
                            id='dropdown3',
                            options=[{'label': i, 'value': i} for i in usjh_AR['lineitem_name'].unique()],
                            value='',
                            multi=True
                        ),
                        html.Div(id='input3'),

                        html.Label('Choose your item(s)'),
                            dcc.Dropdown(
                            id='dropdown4',
                            options=[{'label': i, 'value': i} for i in usjh_AR['lineitem_name'].unique()],
                            value='',
                            multi=True
                        ),
                        html.Div(id='input4'),


                        html.H3("Customer Lifetime Value", style={"padding-left": "150px"}),
                        html.Div(id='input5')
                            ##############

                        
                    ])
                ]),

                dcc.Tab(label='About', 
                        style={"height":"20","verticalAlign":"middle", "text-align": "center"},
                        children=[
                    html.Div([
                        html.Link(href="https://use.fontawesome.com/releases/v5.2.0/css/all.css",rel="stylesheet"),
                        html.Link(href="https://cdn.rawgit.com/plotly/dash-app-stylesheets/2d266c578d2a6e8850ebce48fdb52759b2aef506/stylesheet-oil-and-gas.css",rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Dosis", rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Open+Sans", rel="stylesheet"),
                        html.Link(href="https://fonts.googleapis.com/css?family=Ubuntu", rel="stylesheet"),
                        html.Link(href="https://cdn.rawgit.com/amadoukane96/8a8cfdac5d2cecad866952c52a70a50e/raw/cd5a9bf0b30856f4fc7e3812162c74bfc0ebe011/dash_crm.css", rel="stylesheet"),

                        html.H3("Placeholder")
                    ])
                ])
            ])
        ])
    ])
                 

@app.callback(
    dash.dependencies.Output('table', 'rows'),
    [Input('dropdown', 'value'), Input('dropdown2', 'value')])

def update_table(dropdown, dropdown2):
    if dropdown is None and dropdown2 is None:
        return df.to_dict("records")

    else:
        dff = df[(df["Target_Group"].str.contains('|'.join(dropdown2))) & (df["ID"].str.contains('|'.join(dropdown)))]
        return dff.to_dict("records")
@app.callback(
    Output('result', 'children'),
    [Input('customer_prob', 'value'), Input('slider', 'value')])
def customer_order_prob(name, periods=1):
    if name is not None:
        try:
            t = periods
            individual = summary2.loc[name]
            individual_id = summary2.loc[name].index
            probability = bgf.predict(t, individual['frequency'], individual['recency'], individual['T'])
            return('This customer will make {:.2f} repeat purchases over the course of '.format(probability) + str(periods) + ' months.')
        except ValueError:
            return 'Invalid Input'

################functons for recommendation system###########
@app.callback(
    dash.dependencies.Output('input3', 'children'),
    [dash.dependencies.Input('dropdown3', 'value')])
def callback_a(dropdown_value):
    return 'You\'ve selected the following item(s): "{}"'.format(dropdown_value)

@app.callback(
    dash.dependencies.Output('input4', 'children'),
    [dash.dependencies.Input('dropdown4', 'value')])
def callback_a(dropdown_value):
    return 'You\'ve selected the following item(s): "{}"'.format(dropdown_value)

@app.callback(
    dash.dependencies.Output('input5', 'children'),
    [dash.dependencies.Input('dropdown3', 'value'),dash.dependencies.Input('dropdown4', 'value')])
def prodcut_recommendation(dropdown3, dropdown4):

    if dropdown2==[]:
        return 'Oops, your cart is empty.'

    else:
        sale=set(dropdown3)
        order=set(dropdown4)

        #create the data frame for sale
        s={'lineitem_name':[], 'vendor_category':[], 'frequency':[]}
        for item in sale:
            s['lineitem_name'].append(item)
            s['vendor_category'].append(usjh_AR[usjh_AR['lineitem_name']==item].vendor_category.iloc[0])
            s['frequency'].append(usjh_AR[usjh_AR['lineitem_name']==item].frequency.iloc[0])
        
        sale=pd.DataFrame(s)
        #
        #creat (vendor:category) basing on sale and order
        sale_vc=[]
        for item in sale['lineitem_name']:
            sale_vc.append(usjh_AR[usjh_AR['lineitem_name']==item].vendor_category.iloc[0])
        
        sale_vc=set(sale_vc)
        #
        order_vc=[]
        for item in order:
            order_vc.append(usjh_AR[usjh_AR['lineitem_name']==item].vendor_category.iloc[0])
        
        order_vc=set(order_vc)
        #
        #recommendation basing on the highest support 
        #lookup the association rules
        assoc_rules={'rhs':[], 'support':[]}

        for item in order_vc:
            if len(rules_[rules_['lhs']==item].rhs)>0: #some items have no rules_
                assoc_rules['rhs'].append(rules_[rules_['lhs']==item].rhs.iloc[0])
                assoc_rules['support'].append(rules_[rules_['lhs']==item].support.iloc[0])

        assoc_rules=pd.DataFrame(assoc_rules)

        rhs=assoc_rules.sort_values('support', ascending=False)

        #check if there is on sale item
        recommend=''
        r_support=0
        for item in rhs['rhs']:
        #if there are items on sale in rhs, return the one with the greatest support
            if item in sale_vc:
                if rhs[rhs['rhs']==item].support.iloc[0] > r_support:
                    recommend=item
                    r_support=rhs[rhs['rhs']==item].support.iloc[0]

        #make recommendations basing on recommend
        #if recommend is not empty, which means this is associated on item on sale, recommand the top 3
        if recommend != '':
            rec_items=sale[sale['vendor_category']==recommend].sort_values('frequency',ascending=False)
            #if len(rec_items['lineitem_name'].unique())>3:
            #rec_items=rec_items['lineitem_name'].unique()[:3]
             #else:
            rec_items=rec_items['lineitem_name'].unique()
        #if there is no on sale item, the recommend will be an empty string, 
        #then just simply choose the item with the highest support in rhs
        else :
            recommend=rhs['rhs'].iloc[0]
    #now we have the final recommend, pick the specific items to make recommendation
    #find the lineitem name in recommend with top 3 frequency
        
        rec_items=usjh_AR[usjh_AR['vendor_category']==recommend].sort_values('frequency',ascending=False).lineitem_name
    #there are a lot of duplicated items, get the unique top 3
        rec_items=rec_items.unique()[:3]

        return str(rec_items)






if __name__ == "__main__":
    app.run_server(debug=True)