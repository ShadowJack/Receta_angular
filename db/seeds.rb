# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Recipe.create! [{ name: 'Pelmeshki', instructions: 'Just do it' },
                { name: 'Shawerma', instructions: 'Roll everything in lepeshka'},
                { name: 'Fried potatoes', instructions: 'Fry a lot of potatoes'},
                { name: 'Kulebyaka', instructions: 'Too difficult for you, sorry...'},
                { name: 'Glazunya', instructions: 'Some eggs + becon = hot and spicy'}]