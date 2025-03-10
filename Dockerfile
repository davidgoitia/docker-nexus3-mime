FROM sonatype/nexus3:3.78.1

USER root

RUN uber_jar=/opt/sonatype/nexus/bin/sonatype-nexus-repository-*.jar \
    zip="import sys,zipfile,shutil; z=sys.argv[1]; f=sys.argv[2]; t=z+'.tmp'; zin=zipfile.ZipFile(z,'r'); zout=zipfile.ZipFile(t,'w'); [zout.write(f,arcname=f) if item.filename==f else zout.writestr(item,zin.read(item.filename)) for item in zin.infolist()]; zin.close(); zout.close(); shutil.move(t,z)" ; \
    unzip $uber_jar BOOT-INF/lib/nexus-mime-*.jar ; \
    unzip BOOT-INF/lib/nexus-mime-*.jar builtin-mimetypes.properties ; \
    { \
        echo 'vdi = application/binary' ; \
        echo 'ova = application/binary' ; \
        echo 'ovf = application/binary' ; \
        echo 'vmdf = application/binary' ; \
        echo 'vhd = application/binary' ; \
    } >> builtin-mimetypes.properties ; \
    python3 -c "$zip" BOOT-INF/lib/nexus-mime-*.jar builtin-mimetypes.properties ; \
    python3 -c "$zip" $uber_jar BOOT-INF/lib/nexus-mime-*.jar ; \
    rm -f builtin-mimetypes.properties BOOT-INF/lib/nexus-mime-*.jar

USER nexus
