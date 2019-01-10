#Import Flask Library
from flask import Flask, render_template, request, session, url_for, redirect
import pymysql.cursors
import hashlib

#Initialize the app from Flask
app = Flask(__name__)

#Configure MySQL
conn = pymysql.connect(host='localhost', user='root', password='', db='poly flight ticket booking system', charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)

#Define a route to hello function
@app.route('/')
def welcome():
        #grabs information from the forms
        option = request.form['menu']
        if option == 'search_flight':
                print("Option not ready")
        elif option == 'login':
                return redirect(url_for('login'))
        else:
                return redirect(url_for('register'))

#Homepage
@app.route('/homepage')
def homepage():
        print("Homepage")

#Get flights information
@app.route('/flight')
def flight():
        ISOdate = datetime.datetime.strptime(date, "%m/%d/%Y").strftime("%Y-%m-%d")

#Define route for login
@app.route('/login')
def login():
        return render_template('login.html')

#Define route for register
@app.route('/register')
def register():
        return render_template('register.html')

#Authenticates the login
@app.route('/loginAuth', methods=['GET', 'POST'])
def loginAuth():
        #grabs information from the forms
        user_type = request.form['user_type']
        username = request.form['username']
        password = request.form['password']
        #Hashing password
        hash_object = hashlib.sha1(password)
        hex_dig = hash_object.hexdigest()
        #cursor used to send queries
        cursor = conn.cursor()
        #executes query
        query = 'SELECT * FROM %s WHERE username = %s and password = %s'
        cursor.execute(query, (user_type, username, hex_dig))
        #stores the results in a variable
        data = cursor.fetchone()
        #use fetchall() if you are expecting more than 1 data row
        cursor.close()
        error = None
        if(data):
                #creates a session for the the user
                #session is a built in
                session['username'] = username
                return redirect(url_for('homepage'))
        else:
                #returns an error message to the html page
                error = 'Invalid login or username'
                return render_template('login.html', error=error)

#Authenticates the register
@app.route('/registerAuth', methods=['GET', 'POST'])
def registerAuth():
        #grabs information from the forms
        user_type = request.form['user_type']
        username = request.form['username']
        password = request.form['password']
        #Hashing password
        hash_object = hashlib.sha1(password)
        hex_dig = hash_object.hexdigest()
        #cursor used to send queries
        cursor = conn.cursor()
        #executes query
        query = 'SELECT * FROM %s WHERE username = %s'
        cursor.execute(query, (user_type, username))
        #stores the results in a variable
        data = cursor.fetchone()
        #use fetchall() if you are expecting more than 1 data row
        error = None
        if(data):
                #If the previous query returns data, then user exists
                error = "This user already exists"
                return render_template('register.html', error = error)
        else:
                ins = 'INSERT INTO %s VALUES(%s, %s)'
                cursor.execute(ins, (user_type, username, hex_dig))
                conn.commit()
                cursor.close()
                return render_template('homepage.html')

@app.route('/logout')
def logout():
        session.pop('username')
        return redirect('/')
                
app.secret_key = 'some key that you will never guess'
#Run the app on localhost port 80
#debug = True -> you don't have to restart flask
#for changes to go through, TURN OFF FOR PRODUCTION
if __name__ == "__main__":
        app.run('127.0.0.1')

