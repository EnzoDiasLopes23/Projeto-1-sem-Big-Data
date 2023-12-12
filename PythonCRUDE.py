import psycopg2
from prettytable import PrettyTable
from prettytable import from_db_cursor

# ------------------------------------------------------------------
#  Faz a conexão com o DB na nuvem
# ------------------------------------------------------------------
def connectaDB():
    # --------------------------
    # Info para connectar com
    # --------------------------
    hostname="localhost"
    db_name = 'DataBase'
    usuario = 'postgres'
    senha = '123'

    print(" \n Conectando com base de Dados => ",hostname,"\n")

    conn = psycopg2.connect(user=usuario,
                                  password=senha,
                                  host=hostname,
                                  port="5432",
                                  database=db_name)
    print(" Connectado ao DB == > ",db_name,"  ",hostname)
    return conn

def executaSQL(SQL):
    conn = connectaDB()
    cursor = conn.cursor()
    cursor.execute(SQL)
    myTab = from_db_cursor(cursor)
    myTab.align = "l"
    print(myTab)
    conn.close()

#Executa qualquer Querry
executaSQL("SELECT * FROM casacultura")