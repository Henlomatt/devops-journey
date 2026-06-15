output "ruta_archivo" {
  value       = local_file.mi_primer_recurso.filename
  description = "La ruta del archivo creado"
}