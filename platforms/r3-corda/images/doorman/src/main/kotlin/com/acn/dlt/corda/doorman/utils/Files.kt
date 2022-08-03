package com.acn.dlt.corda.doorman.utils

import java.io.File
import java.io.IOException
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.StandardCopyOption

fun String.toPath() = Paths.get(this)!!
fun String.toFile() = File(this)

/**
 * walks all subdirectories looking for files
 */
fun File.getFiles(): Sequence<File> {
  return this.absoluteFile.walk().filter { it.isFile }
}

/**
 * walks all subdirectories looking for files that match the regulart expression [re]
 */
fun File.getFiles(re: Regex): Sequence<File> {
  return this.absoluteFile.walk()
    .filter {
      it.isFile && it.name.matches(re)
    }
}

operator fun File.div(rhs: String): File {
  return File(this, rhs)
}

@Throws(IOException::class)
fun copyFolder(src: Path, dest: Path) {
  Files.walk(src)
    .forEach { source -> copy(source, dest.resolve(src.relativize(source))) }
}

private fun copy(source: Path, dest: Path) {
  try {
    Files.copy(source, dest, StandardCopyOption.REPLACE_EXISTING)
  } catch (e: Exception) {
    throw RuntimeException(e.message, e)
  }
}
