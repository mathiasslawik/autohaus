module CustomFunctions
  def create_date(d)
    if d == "" then
      nil
    else
      dsplit = d.split(".")

      Date.civil(dsplit[2].to_i, dsplit[1].to_i, dsplit[0].to_i)
    end
  end

  def without_autoincrement(table_name, &block)
    #Schalte Auto-Inkrement aus, da wir neue Einträge erzeugen
    execute("ALTER TABLE `#{table_name}`  CHANGE COLUMN `id` `id` INT(11) NOT NULL");

    yield

    #Schalte Auto-Inkrement wieder ein
    execute("ALTER TABLE `#{table_name}` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT");
  end
end