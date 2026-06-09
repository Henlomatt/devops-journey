# Por qué la Infraestructura como Código es mucho más que simples scripts

*Infraestructura · DevOps · 9 de junio de 2026 · 5 min de lectura*

La configuración manual parece rápida... hasta el día en que deja de serlo. Esto es lo que cambió mi forma de entender la infraestructura.

---

## 1. El problema: el peligro del ClickOps

Todo equipo de infraestructura tiene un servidor que nadie quiere tocar. Ya sabes cuál es: lo montó alguien que ya no está, se configuró a través de una consola web durante varias noches de guardia, y nunca se documentó. Simplemente *funciona*. Nadie sabe exactamente cómo.

Este es el desastre silencioso del **ClickOps**: configurar servidores manualmente, a través de paneles y formularios de interfaz gráfica. Se siente productivo. Levantas una instancia, abres un puerto en el firewall, instalas un paquete, ajustas un fichero de configuración. Listo en minutos. Pero cada uno de esos clics es una decisión sin documentar, un hecho que vive únicamente en el estado de ese servidor y, a veces, en la memoria de alguien.

Con el tiempo, las pequeñas inconsistencias se acumulan. Un servidor tiene una versión ligeramente más antigua de nginx que los demás. Una regla de grupo de seguridad se amplió "solo temporalmente" hace seis meses. Se añadió un cron job directamente en la máquina y nunca se registró en ningún sitio. Esto se llama **configuration drift** (deriva de configuración), y es así como los entornos dejan de ser reproducibles y empiezan a ser poco fiables.

> **El verdadero coste de un paso olvidado** no suele ser un servidor caído. Suele ser un incidente a las 2 de la madrugada en el que el ingeniero de guardia mira dos máquinas que deberían ser idénticas, y no lo son.

---

## 2. La solución: qué cambia realmente la IaC

La Infraestructura como Código reemplaza esos clics manuales por ficheros de texto. En lugar de navegar por una interfaz para crear un servidor, escribes un fichero que describe lo que quieres, y una herramienta lo hace realidad. La infraestructura se convierte en algo que puedes leer, revisar, versionar y volver a ejecutar.

Existen dos filosofías para escribir ese fichero:

La configuración **imperativa** describe los pasos: "Primero, crea una VM. Luego instala nginx. Luego abre el puerto 80." Se parece mucho a cómo los humanos pensamos de forma natural sobre cómo hacer las cosas, pero es frágil: si la VM ya existe, ¿qué debería ocurrir?

La configuración **declarativa** describe el destino: "Debe existir una VM ejecutando nginx con el puerto 80 abierto." La herramienta determina los pasos necesarios para llegar hasta ahí. Este es el enfoque de Terraform, de los patrones más modernos de Ansible y de Kubernetes, y es lo que hace que la IaC sea genuinamente poderosa. Describes el mundo que quieres; la herramienta reconcilia la realidad con tu descripción cada vez que la ejecutas.

```hcl
# Declarativo: describe el estado deseado, no los pasos
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  tags = { Name = "web-server" }
}
```

---

## 3. El momento "¡ajá!": el SysAdmin no desaparece, sube de nivel

Hay un miedo enterrado en las conversaciones sobre IaC que no suele nombrarse directamente: si la automatización se encarga del aprovisionamiento, ¿qué hace realmente un sysadmin?

La conclusión a la que llegué es que el trabajo no se reduce, sino que *sube de nivel*. Antes de la IaC, el valor de un buen sysadmin estaba en sus manos: conocer los comandos correctos, recordar la secuencia adecuada, mantener el modelo mental del sistema en su cabeza. Con la IaC, ese valor se desplaza hacia su *criterio*: diseñar sistemas reproducibles, escribir código de infraestructura que un compañero pueda leer y en el que pueda confiar, pensar en los modos de fallo antes de que ocurran.

La diferencia se parece al salto de un artesano que corta madera a un arquitecto que produce planos. La habilidad del artesano no desaparece, queda codificada en algo a partir de lo cual otros pueden construir. El trabajo pasa de ejecutar a diseñar para la fiabilidad a escala.

> **Lo que la automatización elimina realmente** es el *toil*: el trabajo repetitivo y sin diferenciación que consume tiempo sin construir nada duradero. Lo que deja atrás es el pensamiento.

---

## 4. El error clásico: la trampa que casi todo el mundo comete al principio

El escenario es siempre el mismo: tienes un servidor en producción que se configuró manualmente. Decides ponerlo bajo gestión de Terraform. Escribes el bloque de recurso que lo describe, ejecutas `terraform apply`, y Terraform intenta crear un segundo servidor, porque desde el punto de vista de su fichero de estado, todavía no existe nada.

La solución es `terraform import`, que le dice a Terraform: "este recurso ya existe, aquí es donde vive". Pero la lección más profunda tiene que ver con el propio fichero de estado: el poder de Terraform proviene de rastrear la diferencia entre lo que él conoce y lo que es real. Saltarse el paso de importación rompe esa relación, y Terraform actúa sobre información incompleta.

De forma más amplia: las herramientas de IaC no son envolturas sobre tu infraestructura existente. Son sistemas con su propio modelo de la realidad. Respetar ese modelo —importar lo que ya existe, guardar el estado en un lugar seguro y compartido, no modificar nunca recursos fuera de la herramienta— es lo que separa una configuración de IaC que funciona de una que genera sorpresas.

---

*Etiquetas: infraestructura como código · terraform · devops · sysadmin · automatización*