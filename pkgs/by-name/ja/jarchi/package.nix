{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  archi,
}:

let
  version = "1.12.0";
  bundleVersion = "${version}.qualifier";
  scriptBundle = "com.archimatetool.script_${bundleVersion}.jar";
  scriptInnerJar = "com.archimatetool.script.inner.jar";
  nashornBundle = "com.archimatetool.script.nashorn_${bundleVersion}.jar";
in
stdenvNoCC.mkDerivation {
  pname = "jarchi";
  inherit version;

  src = fetchFromGitHub {
    owner = "archimatetool";
    repo = "archi-scripting-plugin";
    rev = "2a27c18fe305c30e5c50fe3934340bc42544021f";
    hash = "sha256-kfTXfVIZd3H5d7hZkHJmdVTr2QZJuU4KY3as7Gs8WnE=";
  };

  nativeBuildInputs = [ jdk ];
  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    export JAVA_HOME="${jdk}"
    plugin_cp=$(find "${archi}/libexec/plugins" -type f -name '*.jar' | sort | paste -sd: -)
    local_cp=$(find com.archimatetool.script/lib -maxdepth 1 -type f -name '*.jar' | sort | paste -sd: -)
    compile_cp="$plugin_cp:$local_cp"

    mkdir -p build/classes build/stage/script build/stage/nashorn
    find com.archimatetool.script/src -type f -name '*.java' | sort > build/sources.txt

    javac --release 21 -encoding UTF-8 -cp "$compile_cp" -d build/classes @build/sources.txt

    while IFS= read -r resource; do
      rel="''${resource#com.archimatetool.script/src/}"
      install -Dm444 "$resource" "build/classes/$rel"
    done < <(find com.archimatetool.script/src -type f ! -name '*.java' | sort)

    jar --create --file "build/${scriptInnerJar}" -C build/classes .

    cp -r com.archimatetool.script/help build/stage/script/
    cp -r com.archimatetool.script/img build/stage/script/
    cp -r com.archimatetool.script/js build/stage/script/
    cp -r com.archimatetool.script/lib build/stage/script/
    cp -r com.archimatetool.script/schema build/stage/script/
    cp -r com.archimatetool.script/templates build/stage/script/
    cp com.archimatetool.script/LICENSE.txt build/stage/script/
    cp com.archimatetool.script/plugin.properties build/stage/script/
    cp com.archimatetool.script/plugin.xml build/stage/script/
    cp "build/${scriptInnerJar}" "build/stage/script/com.archimatetool.script.jar"

    jar --create \
      --file "build/${scriptBundle}" \
      --manifest com.archimatetool.script/META-INF/MANIFEST.MF \
      -C build/stage/script .

    cp com.archimatetool.script.nashorn/LICENSE.txt build/stage/nashorn/
    cp com.archimatetool.script.nashorn/asm-9.0.jar build/stage/nashorn/
    cp com.archimatetool.script.nashorn/asm-commons-9.0.jar build/stage/nashorn/
    cp com.archimatetool.script.nashorn/asm-util-9.0.jar build/stage/nashorn/
    cp com.archimatetool.script.nashorn/nashorn-core-15.4.jar build/stage/nashorn/

    jar --create \
      --file "build/${nashornBundle}" \
      --manifest com.archimatetool.script.nashorn/META-INF/MANIFEST.MF \
      -C build/stage/nashorn .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/archi-dropins"
    install -Dm444 "build/${scriptBundle}" "$out/share/archi-dropins/${scriptBundle}"
    install -Dm444 "build/${nashornBundle}" "$out/share/archi-dropins/${nashornBundle}"

    runHook postInstall
  '';

  meta = {
    description = "jArchi scripting plugin dropins for Archi";
    homepage = "https://github.com/archimatetool/archi-scripting-plugin";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
