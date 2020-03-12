package net.ianoc.protobufbin;

import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.Files;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Iterator;

class EditorMain {

  public static void main(String[] args) {
    try {
      Path workingPath = Paths.get(args[0]);

      List<String> lines = Files.readAllLines(workingPath, StandardCharsets.UTF_8);

      int idx = 0;
      int licencesOffset = -1;
      Iterator<String> iter = lines.iterator();
      while(iter.hasNext() && licencesOffset == -1) {
        String line = iter.next();
        if(line.startsWith("licenses(")) {
          licencesOffset = idx;
        }
        idx += 1;
      }
      if(licencesOffset == -1) {
        System.err.println("Unable to find any load statements?");
        System.exit(-1);
      }

      lines.add(licencesOffset, "get_proto_binaries()");
      lines.add(licencesOffset, "load(\":protoc.bzl\", \"get_proto_binaries\")");

    Files.write(workingPath, lines, StandardCharsets.UTF_8);
    } catch(Exception e) {
      throw new RuntimeException(e);
    }
  }
}
