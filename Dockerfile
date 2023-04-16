FROM sonatype/nexus3:3.51.0

USER root

RUN jar_file=/opt/sonatype/nexus/system/org/sonatype/nexus/nexus-mime/*/nexus-mime-*.jar ; \
    jar xf $jar_file builtin-mimetypes.properties ; \
    { \
        echo 'vdi = application/binary' ; \
        echo 'ova = application/binary' ; \
        echo 'ovf = application/binary' ; \
        echo 'vmdf = application/binary' ; \
        echo 'vhd = application/binary' ; \
    } >> builtin-mimetypes.properties ; \
    jar uf $jar_file builtin-mimetypes.properties ; \
    rm -f builtin-mimetypes.properties

USER nexus
