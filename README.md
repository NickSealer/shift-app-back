# README

- [Instrucciones](#instrucciones)
- [Sobre la app](#sobre-la-app)
- [Características](#características)
- [Alcance](#alcance)
- [Restricciones](#restricciones)
- [Componentes](#componentes)
- [Arquitrectura](#arquitectura)

## Instrucciones

Los seeds crean 4 usuarios: 1 admin/supervisor y 3 users normales y 2 servicios por defecto, asociados todos entre sí. Ya se pueden usar cualquiera de ellos. Los users son para crear hojas de disponibilidad y confirmarlas, y el admin para organizar el cronograma y confirmarlo.

### Dependencias

- Ruby 3.3.0
- Rails 7.1.3.4
- PostgreSQL 14.11

### Instalación
Clonar el repositorio y ejecutar los siguientes comandos:

```
bundle install
```
### Configuración de la DB
Crear el archivo `.env` y copiar las ENV vars con sus credenciales locales en [.env.example](.env.example) file
```
DATABASE=database-name
DATABASE_USER=your-sa-name
DATABASE_PASS=your-sa-password
DATABASE_PORT=5432
DATABASE_HOST=localhost
```
Después de eso, correr los siguientes comandos:
```
rails db:create
rails db:migrate
rails db:seed
```

### Optional:
Para correr los test o ver el resultado en la siguiente imágen: [Image](public/code_coverage.png).
```
rspec
```
### Iniciando la app:
Para ingresar, los usuarios están en: [seeds.rb](db/seeds.rb) o copiarlos de aqui:
```
rails server
```
Users:
```
<!-- Usuarios estándar-->
email: ernesto@email.com
password: Password123?

email: barbara@email.com
password: Password123?

email: benjamin@email.com
password: Password123?

<!-- Usuario admin -->
email: admin@email.com
password: Password123?

```

## Sobre la app
API para el control de turnos de trabajo. Con ella, el personal asignado a los servicios o compañías pueden crear sus calendarios de disponibilidad desde la semana actual hasta 4 más en el futuro, con el objetivo de dar a conocer su disponibilidad de 5 semanas a su supervisor. Permite realizar los ajustes necesarios antes de confirmar su hoja de turnos para mayor comodidad. La aplicación también permite la asignación de los turnos por parte del supervisor para cumplir con las horas semanales que exige el servicio, al tiempo que le da una visión de quienes han confirmado su disponibilidad y quienes no, lo que permite tener un control al momento de confirmar la hoja de turnos.

> Nota: Es una aplicación MVP para el control de turnos de trabajo, por ello cuenta con algunas restricciones y funciona con un set de usuarios inicial.

> Aplicación FE (Recat.js | Completed): [https://github.com/NickSealer/shift-app-front](https://github.com/NickSealer/shift-app-front)

>Aplicación FE (Vue.js | Incompleted): [https://github.com/NickSealer/vue-shift-app](https://github.com/NickSealer/vue-shift-app)

## Características

- Login de usuarios.
- Logout de usuarios.
- Visualización de servicios asignados.
- Los horarios confirmados son resaltados con un color azul verdoso.
- Los horarios sin confirmar se resaltan con una tonalidad rojiza.

**Rol user:**
- Visualización de disponibilidades.
- Creación de disponibilidad.
- Actualización de disponibilidad.
- Confirmación de disponibilidad.

**Rol admin:**
- Visualización de hojas de turno.
- Creación de hojas de turno.
- Asignación de disponibilidades.
- Confirmación de la hoja de turnos.
- Eliminación de hojas de turno.


## Alcance
- El inicio de sesión reconoce el rol del usuario y lo redirige a las vistas correspondientes.
- Visualización de todos los servicios en los que se esté asignado.

**Rol user:**
- Visualización de sus hojas de disponibilidad por servicio.
- Creación de hojas de disponibilidad, con selección de 5 semanas, están se van actualizando a medida que hay cambio de semana.
- Actualización de sus hojas de disponibilidad.
- Confirmación de sus hojas de disponibilidad.

**Rol admin:**
- Visualización de hojas de turnos por servicio.
- Creación automática de hojas de turno.
- Confirmación de las hojas de turno.

## Restricciones / Reglas
- Creación de hojas de disponibilidad o de turnos únicos por número de semana, año y servicio.
- No se permite la eliminación de hojas de disponibilidad, para eso se pueden actualizar o confirmar, es responsabilidad del usuario registrar su disponibilidad, ya sea con fechas o no para que el flujo de turnos funcione bien al momento de que el admin/supervisor los quiera confirmar.
- No se permiten cambios en las hojas de disponibilidad una vez confirmadas.
- Creación automática de hojas de turno. El sistema es capaz de identificar el consecutivo de la semana y año, y asociar a ésta los usuarios implicados que deben registrar su disponibilidad para esa semana y servicio.
- Para confirmar una hoja de turnos, el admin/supervisor puede elegir quienes estarán en según qué día y hora presentes, ya sea turno en solitario o compartido.
- El sistema le indica al admin/supervisor las horas requeridas por el servicio y las horas disponibles por los usuarios en la vista de confirmar turno, de ese modo puede ver si hacen falta o se excede y cumplir con las horas solicitadas.
- No se permite la creación de hojas de turnos donde las horas no coincidan con las requeridas por el servicio, tienen que ser iguales.
- No se permite la creación de hojas de turnos si todos los usuarios asignados a él no han cargado sus hojas de disponibilidad.
- No se permite la eliminación de hojas de turno una vez confirmadas.
- No se permite crear más hojas de turnos, cuando estas son un total de 10 sin confirmar.

## Componentes

Estos son los modelos implicados:
- Service
- User
- Assigment
- Availability
- Day
- Shift

### Comunicación:

- Inicialmente tanto `User` como `Service` pueden existir sin depender de otros modelos.
- La asociación se hace internamente, siendo de muchos a muchos a través de `Assigment`.
- Un `User` puede tener muchas `Availability`, las cuales también se asocian con un `Service`.
- Un `Availability` tiene muchas asociaciones a `Day`, éste registra la fecha, el día y la hora de disponibilidad. Si no está disponible el usuario para ese momento, simplemente no se crea el registro, y en la vista se evalúa si está o no disponible de acuerdo con la data de `Day` en base al horario que `Service` exige, haciendo que sean totalmente dinámicas las tablas de horarios. La combinación de `week`, `year` y `service_id` es única, para así garantizar una sóla hoja por semana, servicio y usuario.
- `Service`, tiene un número total de `Availability` a través de sus usuarios registrados con el rol `user`, con eso, y en base a ello se sabe cuantas hojas de disponibilidad se necesitan confirmadas para programar la hoja de turnos (`Shift`). El total de horas se calcula en base al array de horarios de sus campos como días.
- La hoja de turnos (`Shift`), pertenece a un solo `Service` y a un `User` identificado con rol de `admin`. Se identifica cuáles son sus disponibilidades (`Availability`) por medio de una única identificación combinando `week`, `year` y `service_id`, ya sea que estén confirmadas o no. Cuando se confirma el Shift significa que es el cronograma que se ha establecido, impidiendo cambios y su eliminación. Para confirmar basta con que todas las `Availability` estén confirmadas.
- `Day`, simplemente guarda la fecha y hora de disponibilidad del usuario. Se asocia perteneciendo a un `Availability`, y es necesario para hacer match con el calendario que pide el `Service`.

## Arquitectura:

- Se emplea una arquitectura RESTFull
- Sus principales enpoints son:

| Method | Resource |
|--------|--------|
| POST | /sign_in |
| DELETE | /sign_out |
| GET | /services/:id |
| GET | /services/:service_id/availabilities |
| POST | /services/:service_id/availabilities |
| PUT | /services/:service_id/availabilities/:id |
| GET | /services/:id/shifts |
| POST | /services/:id/shifts |
| GET | /services/:service_id/shifts/:id |
| PUT | /services/:service_id/shifts/:id |
| DELETE | /services/:service_id/shifts/:id |
| GET | /weeks |

- ServiceObject para cambios en los registros.
- PolicyObject para aplicar reglas específicas.
- FactoryMethod para inicializar los objetos.
