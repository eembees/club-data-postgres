import streamlit as st
import psycopg2
import pandas as pd
import plotly.express as px

def get_connection():
    return psycopg2.connect(
        host="localhost",    
        database="postgres",
        user="postgres",     
        password="postgres", 
        port="5432"          
    )
SELECT_QUERY =  """
    SELECT gender, weekday, count
    FROM public.gender_day_preferences  -- Replace with your schema and table
    ORDER BY gender, weekday;
    """
BACKWARDS_WEEKDAY_MAP = {
"Sunday":0,
"Monday":1,
"Tuesday":2,
"Wednesday":3,
"Thursday":4,
"Friday":5,
"Saturday":6,
} # this could be circumvented by being smart in building sql but in this case we dont want smart we want to show off functionalities


# Function to fetch data from the gender_day_preferences model
def get_gender_day_preferences():
    query = SELECT_QUERY
    
    # Connect to the database
    conn = get_connection()
    
    # Fetch data using pandas read_sql function
    df = pd.read_sql(query, conn)
    
    # Close the connection
    conn.close()
    
    return df

def get_hourly_distribution(selected_weekday):
    # dynamically build query bc its a string, easy
    query = """
    SELECT EXTRACT(HOUR FROM timestmp) AS hour, COUNT(*) AS count
    FROM public.stg__hourly_door
    """
    if selected_weekday != "All Days":
        query += f"WHERE day_of_week = {BACKWARDS_WEEKDAY_MAP[selected_weekday]}"
    
    query += """
    GROUP BY hour
    ORDER BY hour;
    """
    
    # Connect to the database
    conn = get_connection()
    
    # Fetch data using pandas read_sql function
    df = pd.read_sql(query, conn)
    
    # Close the connection
    conn.close()
    
    return df

def main():
    st.title("Gender Day Preferences Insights")
    
    # Fetch gender day preferences data
    df_gender = get_gender_day_preferences()    

    st.write("### Gender and Day of Week Preferences")
    
    # Pivot the data to create a stacked bar chart for gender distribution
    pivot_df = df_gender.pivot_table(index='weekday', columns='gender', values='count', aggfunc='sum', fill_value=0)
    
    # Plot the stacked bar chart for gender distribution
    st.write("### Stacked Bar Chart of Gender Distribution by Weekday")
    fig = px.bar(pivot_df, 
                 x=pivot_df.index, 
                 y=pivot_df.columns, 
                 labels={'value': 'Count', 'variable': 'Gender'},
                 title="Gender Distribution by Day of Week", 
                 height=400)
    fig.update_layout(barmode='stack', xaxis_title="Weekday", yaxis_title="Number of Visits")
    st.plotly_chart(fig)
    
    # Add a dropdown for selecting the weekday
    weekdays = ['All Days', '0', '1', '2', '3', '4', '5', '6']
    weekday_names = ['All Days', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    
    selected_weekday = st.selectbox('Select Weekday for Hourly Distribution', weekday_names, index=0)
    
    # Fetch hourly distribution data for the selected weekday
    df_hourly = get_hourly_distribution(selected_weekday)
    
    # Show hourly distribution data
    if df_hourly.empty:
        st.write(f"No data available for {selected_weekday}")
    else:
        st.write(f"### Hourly Distribution of Visits - {selected_weekday}")
        fig_hourly = px.bar(df_hourly, 
                            x='hour', 
                            y='count', 
                            labels={'hour': 'Hour of Day', 'count': 'Number of Visits'},
                            title=f"Hourly Distribution of Visits - {selected_weekday}", 
                            height=400)
        st.plotly_chart(fig_hourly)

# Run the Streamlit app
if __name__ == "__main__":
    main()
