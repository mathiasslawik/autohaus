require File.dirname(__FILE__) + '/custom_functions.rb'

class GenerateOrdersInvoices < ActiveRecord::Migration
  extend CustomFunctions

  def self.up
    #Auftrags-Tabelle, enthält Aufträge von Kunden
    create_table "orders" do |t|
      t.integer "contact_id"

      #Auftragsnummer (Leider teilweise doppelt vergeben)
      t.integer "number"
    end

    #Fremdschlüsselbeziehung
    add_foreign_key(:orders, :contacts, :dependent => :delete)

    #Rechnungs-Tabelle, enthält Rechnungen zu Aufträgen
    create_table "invoices" do |t|
      #Auftrag, zu dem diese Rechnung gehört
      t.integer "order_id"

      #Rechnungsnummer (Leider teilweise doppelt vergeben)
      t.integer "number"

      #Art der Rechnung
      t.string "invoice_type"

      #Betrag der Rechnung in Cent
      t.integer "amount"

      #Rechnungsdatum
      t.date "date"

      #Hu/Au - Rechnung
      t.boolean "special"
    end

    #Fremdschlüsselbeziehung
    add_foreign_key(:invoices, :orders, :dependent => :delete)

    #Lies Aufträge und Rechnungen ein
    File.open "db/migrate/orderinvoice.csv", "r" do |infile|
      #Erste Zeile überspringen
      infile.gets

      #Alle Zeilen durchgehen
      while line = infile.gets do
        #Teile String auf
        s = line.split(";")

        #0=Firmen-Id
        #1=Auftragsnummer
        #2=Rechnungsnummer
        #3=Art
        #4=Betrag
        #5=Datum
        #6=HUAU-Rechnung
        #7=Kontakt_Name

        #Finde den Kontakt
        contact = Contact.find(s[0])

        #Erstelle Auftrag
        order = contact.orders.create(:number => s[1])

        #Erzeuge Rechnung
        order.invoices.create(:number => s[2], :invoice_type => s[3], :amount => Float(s[4].gsub(",", ".")) * 100, :date => create_date(s[5]), :special => s[6] == "nein" ? false : true)
      end
    end
  end

  def self.down
    drop_table "orders"
    drop_table "invoices"
  end
end