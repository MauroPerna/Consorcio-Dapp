# Consorcio-Dapp

Sistema para que la administración de un consorcio de un edificio se haga mediante una dApp. Las características pensadas son:

+ Debe haber un administrador, que va a ser quien haga deploy del contrato

+ Pueden haber varios tipos de usuarios (pensando en usar herencia). Por ejemplo: usuarios que tengan responsabilidad de pagar expensas (y dentro de estos, que se dividan en inquilinos y propietarios) y usuarios que tengan que recibir un pago, por ejemplo un empleado del edificio como un portero o encargado.

+ El admin es el unico que puede agregar usuarios. Ya sea tipo inquilino o tipo empleado

+ La app debe tener una lista de usuarios que pagan expensas (inquilino/propietario) y debe tener una lista de usuarios de tipo empleados (portero/plomero/seguridad, etc)

+ Los usuarios que pagan expensas, deben pagar a través de la app. Esta vez debe enviarse el valor en ethers y validar que la transferencia se haga correctamente.

+ La app debe tener una lista de pagos que debe hacer (sueldos, arreglos, servicios, etc)

+ La dApp debe tener un balance para saber con cuánta plata cuenta para ejecutar los pagos correspondientes.

+ La app debe tener una función para pagar los servicios de la lista. Solamente el admin puede realizar el pago.

+ La app debe tener una función para pagar cosas puntuales o eventos por separado. (Solamente el administrador puede hacer uso de esta función)

+ Tener en cuenta que los empleados y servicios, van a ser indicados por un address. Con lo cual, un pago significa transferir ethers desde el contrato hacia otra cuenta (address).

+ Cada contract debe ir un archivo separado (para usar imports)
