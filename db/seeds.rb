# frozen_string_literal: true

User.find_or_create_by(email: 'ernesto@email.com') do |user|
  user.name = 'Ernesto'
  user.lastname = 'Villalobos'
  user.password = 'Password123?'
end

User.find_or_create_by(email: 'barbara@email.com') do |user|
  user.name = 'Bárbara'
  user.lastname = 'Torres'
  user.password = 'Password123?'
end

User.find_or_create_by(email: 'benjamin@email.com') do |user|
  user.name = 'Benjamín'
  user.lastname = 'Arco'
  user.password = 'Password123?'
end

User.find_or_create_by(email: 'admin@email.com') do |user|
  user.name = 'Admin'
  user.lastname = 'Admin'
  user.password = 'Password123?'
  user.role = 1
end

s1 = Service.find_or_create_by(name: 'Company A') do |service|
  service.monday = ['19:00-20:00', '20:00-21:00', '21:00-22:00', '22:00-23:00', '23:00-00:00']
  service.tuesday = ['19:00-20:00', '20:00-21:00', '21:00-22:00', '22:00-23:00', '23:00-00:00']
  service.wednesday = ['19:00-20:00', '20:00-21:00', '21:00-22:00', '22:00-23:00', '23:00-00:00']
  service.thursday = ['19:00-20:00', '20:00-21:00', '21:00-22:00', '22:00-23:00', '23:00-00:00']
  service.friday = ['19:00-20:00', '20:00-21:00', '21:00-22:00', '22:00-23:00', '23:00-00:00']
  service.saturday = ['10:00-11:00', '11:00-12:00', '12:00-13:00', '13:00-14:00', '14:00-15:00', '15:00-16:00', '16:00-17:00', '17:00-18:00', '18:00-19:00', '19:00-20:00', '20:00-21:00', '21:00-22:00',
                      '22:00-23:00', '23:00-00:00']
  service.sunday = ['10:00-11:00', '11:00-12:00', '12:00-13:00', '13:00-14:00', '14:00-15:00', '15:00-16:00', '16:00-17:00', '17:00-18:00', '18:00-19:00', '19:00-20:00', '20:00-21:00', '21:00-22:00',
                    '22:00-23:00', '23:00-00:00']
end

s2 = Service.find_or_create_by(name: 'Company B') do |service|
  service.monday = ['08:00-09:00', '09:00-10:00', '10:00-11:00', '11:00-12:00']
  service.tuesday = ['08:00-09:00', '09:00-10:00', '10:00-11:00', '11:00-12:00']
  service.wednesday = ['08:00-09:00', '09:00-10:00', '10:00-11:00', '11:00-12:00']
  service.thursday = ['08:00-09:00', '09:00-10:00', '10:00-11:00', '11:00-12:00']
  service.friday = ['08:00-09:00', '09:00-10:00', '10:00-11:00', '11:00-12:00']
  service.saturday = []
  service.sunday = []
end

s1.users << User.all
s2.users << User.all
