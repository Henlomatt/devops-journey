resource "local_file" "mi_primer_recurso" {
    content  = var.contenido_archivo
    filename = var.nombre_archivo
}