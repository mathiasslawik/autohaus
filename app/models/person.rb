class Person < Contact
  def name
    given_name + " " + surname
  end

  def sort
    surname + ", " + given_name
  end
end