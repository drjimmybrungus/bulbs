import os
import sys
import psycopg2
import configparser
import bulbs.views.register as rview

from bulbs.components import db
from setuptools import setup, find_packages


here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, 'README.md')) as f:
    README = f.read()
with open(os.path.join(here, 'CHANGES.txt')) as f:
    CHANGES = f.read()

requires = [
    'pyramid',
    'pyramid_mako',
    'pyramid_debugtoolbar',
    'waitress',
    'pyramid_beaker',
    'psycopg2',
    'bcrypt',
    'unicode-slugify'
    ]

def write_sql_config(dbname, dbuser, dbpass, dbport):
    """Write the database configuration to file sql.conf"""
    config = configparser.RawConfigParser()
    config.add_section("auth")
    config.set("auth", "name", dbname)
    config.set("auth", "user", dbuser)
    config.set("auth", "pass", dbpass)
    config.set("auth", "port", dbport)
    with open("sql.cfg", "w") as configfile:
        config.write(configfile)

def db_setup(dbname, dbuser, dbpass, dbport):
    """Setup the database and forum administrator account."""
    try:
        con = psycopg2.connect(
            database=dbname, user=dbuser, 
            password=dbpass, port=dbport
        )
    except Exception as e:
        raise Exception("Could not connect to database...")
            
    write_sql_config(dbname, dbuser, dbpass, dbport)
    
    tables = [
        "CREATE TABLE IF NOT EXISTS bulbs_category (id SERIAL, title varchar(64), description text, date timestamp without time zone, ip varchar(20), slug varchar(256))",
        "CREATE TABLE IF NOT EXISTS bulbs_group (id SERIAL, permission smallint, name varchar(32), description varchar(256))",
        "CREATE TABLE IF NOT EXISTS bulbs_moderator (subcat_id smallint, user_id smallint, username varchar(36))",
        "CREATE TABLE IF NOT EXISTS bulbs_post (id SERIAL, subcategory_id integer, user_id integer, parent_post integer, title varchar(90), content text, ispoll boolean, date timestamp without time zone, ip varchar(20), latest_reply timestamp without time zone, islocked boolean, slug varchar(256))",
        "CREATE TABLE IF NOT EXISTS bulbs_postview (post_id integer, views integer)",
        "CREATE TABLE IF NOT EXISTS bulbs_subcategory (id SERIAL, category_id integer, title varchar(45), description text, date timestamp without time zone, ip varchar(20), slug varchar(256))",
        "CREATE TABLE IF NOT EXISTS bulbs_user (id SERIAL, username varchar(36), password bytea, email varchar(128), date timestamp without time zone, karma float, ip varchar(20), title varchar(128), name varchar(64), city varchar(64), state varchar(64), country varchar(64), biography text, avatar varchar(256), group_id smallint)"
    ]
        
    con.autocommit = True
    cursor = con.cursor()
        
    for query in tables:
        try:
            cursor.execute(query)
        except psycopg2.ProgrammingError as e:
            print (e)
            choice = input(" ... Continue? [y/n] ")
            if choice.startswith("n"):
                exit(1)
        print ("CREATING TABLE {0} ... [ OK ]".format(query.split()[5]))
    
    return True

def admin_setup(con):
    db.init()
    username = input("Username: ")
    while 1:
        password = input("Password: ")
        password2 = input("Password: ")
        if password != password2:
            print ("You made a mistake typing in your password, please try again")
        else:
            break
    email = input("Email: ")    
    rview.register_user(username, password, email, "1337")
    
    return True

def bulbs_setup():
    """Install and configure Bulbs."""
    dbname = input("Database name: ")
    dbuser = input("Database user: ")
    dbpass = input("Database pass: ")
    dbport = input("Database port [5432]: ")

    if dbport == "":
        dbport = 5432
        
    db_setup(dbname, dbuser, dbpass, dbport)
    
    print ("Enter information for the forum administrator")
    
if sys.argv[1] == "db":
    bulbs_setup()
elif sys.arv[1] == "dbadmin":
    bulbs_setup()
    admin_setup()
elif sys.argv[1] == "admin":
    admin_setup()
    
setup(name='Bulbs',
      version='0.2dev',
      description='Bulbs is a free, highly customizable, minimal open source bulletin board.',
      long_description=README + '\n\n' + CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pyramid",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='John Murphy',
      author_email='john@yepperx.ca',
      url='',
      keywords='web pyramid pylons python internet forum yepperx bulletin board message',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      install_requires=requires,
      tests_require=requires,
      test_suite="bulbs",
      entry_points="""\
      [paste.app_factory]
      main = bulbs:main
      """,
      )
