require File.dirname(__FILE__) + '/custom_functions.rb'

class GenerateContacts < ActiveRecord::Migration
  extend CustomFunctions

  def self.up
    #Kontakte-Tabelle: Enthält Personen und Firmen 
    create_table "contacts" do |t|
      #Personen
      t.string "given_name"
      t.string "surname"
      
      #Firmen
      t.string "title"
      
      #Der Typ des Objekts
      t.string "type"
      
      #Die übergreifenden Felder
      t.string "address"
      t.string "city"
      t.string "zipcode"
      t.string "telephone"
    end

    without_autoincrement "contacts" do
      #Lies Kontakte ein
      File.open "db/migrate/contacts.csv", "r" do |infile|
        #Erste Zeile überspringen
        infile.gets

        #Alle Zeilen durchgehen
        while line = infile.gets do
          #Teile String auf
          s = line.split(";")

          #0 = Id
          #1 = Vorname
          #2 = Name
          #3 = Firma1
          #4 = Anrede
          #8 = Telefon_1
          #9 = Plz
          #10= Ort
          #11= Adresse

          c =
            #Eine Firma
            if s[1] == "" then
              Company.new(:title => s[3], :address => s[11], :city => s[10], :zipcode => s[9], :telephone => s[8])
            #Eine Person
            else
              Person.new(:given_name => s[1], :surname => s[2], :address => s[11], :city => s[10], :zipcode => s[9], :telephone => s[8])
            end

          #ID ist normalerweise geschützt. Um eine ID manuell anzugeben, kann
          #nicht .create benutzt werden, sondern nur .new, ID setzen und speichern
          c.id = s[0]
          c.save!
        end
      end
    end
  end

  def self.down
    drop_table "contacts"
  end
end
