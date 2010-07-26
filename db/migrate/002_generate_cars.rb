require File.dirname(__FILE__) + '/custom_functions.rb'

class GenerateCars < ActiveRecord::Migration
  extend CustomFunctions

  def self.up
    #Auto-Tabelle, enthält Autos
    create_table "cars" do |t|
      #Das Kennzeichen
      t.string "license_number"
      
      #Die Erstzulassung
      t.date "registration_date"
      
      #Das HU-Datum
      t.date "inspection_date"
      
      #Der Kilometerstand
      t.integer "mileage"
      
      #Der letzte Besuch
      t.date "last_seen"
      
      #Der Kunde, dessen Auto dies ist
      t.integer "contact_id"
    end

    #Fremdschlüsselbeziehung
    add_foreign_key(:cars, :contacts, :dependent => :delete)

    Contact.reset_column_information

    #Lies Autos ein
    File.open "db/migrate/cars.csv", "r" do |infile|
      #Erste Zeile überspringen
      infile.gets
      
      #Alle Zeilen durchgehen
      while line = infile.gets do
        #Teile String auf
        s = line.split(";")
        
        #0=Kontakt_Id
        #1=Kennzeichen
        #2=Datum_ez
        #3=Datum_hu
        #4=Km_stand
        #5=Letzter_besuch
        #6=Kontakt_Name

        #Finde den Kontakt
        contact = Contact.find(s[0])
        
        if contact then
          #Erzeuge neues Auto
          contact.cars.create(:license_number => s[1], :registration_date => create_date(s[2]), :inspection_date => create_date(s[3]), :mileage => (s[4] == "0" ? nil : s[4]), :last_seen => create_date(s[5]))
        end
      end
    end
  end

  def self.down
    drop_table "cars"
  end
end
