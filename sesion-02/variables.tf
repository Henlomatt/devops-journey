variable "nombre_archivo" {
  description = "El nombre del archivo que vamos a crear"
  type        = string
  default     = "hola.txt"
}

variable "contenido_archivo" {
  description = "El contenido que tendrá el archivo"
  type        = string
  default     = "Este es el contenido por defecto."
}