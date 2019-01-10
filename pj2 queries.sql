create database air_ticket_reservation_system;

create table Customer(
email varchar(255) primary key,
name varchar(255),
password varchar(255),
building_number int,
street varchar(255),
city varchar(255),
state varchar(255),
phone_number varchar(20),
passport_number varchar(255),
passport_country varchar(255),
passport_expiration date,
date_of_birth date);

create table Airline(
name varchar(255) primary key);

create table Booking_Agent(
email varchar(255) PRIMARY KEY,
password varchar(255),
booking_agent_id varchar(255));

create index agent_id on Booking_Agent(booking_agent_id);

create table Airline_Staff (
username varchar(255) primary key, 
password varchar(255),
first_name varchar(20),
last_name varchar(20),
date_of_birth date, 
airline_name varchar(255), 
foreign key (airline_name) references Airline(name) on delete cascade);

create table Airport(
name varchar(255) primary key,
city varchar(255));

create table Airplane(
id varchar(255),
seats int,
airline_name varchar(255), 
primary key(id,airline_name),
foreign key (airline_name) references Airline(name)on delete cascade);

create table Flight (
flight_num int, 
departure_time datetime, 
arrival_time datetime,
price numeric(7,2) unsigned,
status varchar(255) check (status in ('upcoming','in-progress','delayed')),
airline_name varchar(255),
airplane_id varchar(255),
depart_airport_name varchar(255), 
arrive_airport_name varchar (255),
primary key (flight_num,airline_name),
foreign key (airline_name) references Airline(name)on delete cascade,
foreign key (airplane_id,airline_name) references Airplane(id,airline_name) on delete cascade,
foreign key (depart_airport_name) references Airport(name) on delete cascade,
foreign key (arrive_airport_name) references Airport(name)on delete cascade);

create table Ticket(
ticket_id varchar(255) primary key,
flight_num int,
airline_name varchar(255),
foreign key (flight_num,airline_name) references Flight(flight_num,airline_name)on delete cascade);


create table purchase(
ticket_id varchar(255), 
customer_email varchar(255),
booking_agent_id varchar(255),
primary key (ticket_id,customer_email),
foreign key (ticket_id) references Ticket(ticket_id) on delete cascade,
foreign key (customer_email) references Customer(email) on delete cascade,
foreign key (booking_agent_id) references Booking_Agent(booking_agent_id)on delete set null);


insert into Airline values ("Emirate");

insert into Airport values 
("JFK","NYC"),
("Chicago International Airport", "Chicago");

insert into Customer values
("example@example.com","John","fuiwnf",57,"Fulton 

St.","NYC","NY","6466984434","UN393748F3892","UN","2020-12-21","1970-01-13"),
("dummy@dumb.com","doe","2fh38df823",330,"Atlantic Ave.","Brooklyn", 

"NY","3252775345","UN482398TP4438","UN","2040-01-23","2000-06-28");

insert into Booking_Agent values("booking@agent.com","sdfwef4","bookyman");

insert into Airplane values
("F35",2,"Emirate"),
("F22",2,"Emirate");

insert into Airline_Staff values ("express","darkcoffee","won","don","1950-01-01","Emirate");

insert into Flight values
(234, "2017-08-06 23:24:25", "2017-08-08 12:12:12",500,"in-progress","Emirate","F35","JFK","Chicago International Airport"),
(345, "2017-08-06 23:24:25" , "2017-08-08 12:12:12" , 500,"delayed","Emirate","F22","Chicago International Airport","JFK"),
(456, "2017-08-08 12:15:00" ,"2017-08-10 23:24:25"  ,500,"upcoming","Emirate","F35","Chicago International Airport","JFK");

insert into Ticket values
("JtoC",234, "Emirate"),
("J2C",234, "Emirate");

insert into purchase values
("JtoC","example@example.com","bookyman"),
("J2C","dummy@dumb.com",null);

select * from Flight where status = "upcoming";

select * from Flight where status = "delayed";

select c.name from Customer c, purchase p where c.email = p.customer_email and p.booking_agent_email is not null;

select id from Airplane where airline_name = "Emirate"