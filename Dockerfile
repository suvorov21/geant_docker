FROM bars21/dev_base as dev_hep_geant
COPY --from=bars21/dev_base $COMMON_BUILD_PREFIX $COMMON_BUILD_PREFIX
COPY --from=bars21/dev_base $COMMON_INSTALL_PREFIX $COMMON_INSTALL_PREFIX

# GEANT4 10.*
ENV G4_VER=10.06.p03
RUN source $COMMON_INSTALL_PREFIX/setup.sh && \
    cd $COMMON_BUILD_PREFIX && \
    wget http://cern.ch/geant4-data/releases/geant4.${G4_VER}.tar.gz && \
    tar -xzf geant4.10.*.tar.gz && \
    mkdir -p geant_build &&\
    cd geant_build && \
    cmake3 -DCMAKE_INSTALL_PREFIX=$COMMON_INSTALL_PREFIX \
          -DGEANT4_INSTALL_DATA=ON \
          -DGEANT4_USE_OPENGL_X11=ON \
          -DGEANT4_USE_RAYTRACER_X11=ON \
          -DGEANT4_USE_GDML=ON \
          ../geant4.10* && \
    make -j3 install && \
    cd $COMMON_BUILD_PREFIX && \
    rm -rf $COMMON_BUILD_PREFIX/* &&\
    echo '# GEANT4 Specific Paths' >> $COMMON_INSTALL_PREFIX/setup.sh &&\
    echo 'source $COMMON_INSTALL_PREFIX/bin/geant4.sh' >> $COMMON_INSTALL_PREFIX/setup.sh &&\
    echo 'export GEANT4_INCLUDE=$COMMON_INSTALL_PREFIX/include/Geant4' >> $COMMON_INSTALL_PREFIX/setup.sh &&\
    echo 'export GEANT4_INSTALL_BIN=$COMMON_INSTALL_PREFIX/bin' >> $COMMON_INSTALL_PREFIX/setup.sh &&\
    echo 'export GEANT4_LIBRARY=$COMMON_INSTALL_PREFIX/lib64' >> $COMMON_INSTALL_PREFIX/setup.sh &&\
    echo 'export GEANT4_LIBRARY_DIR=$COMMON_INSTALL_PREFIX/lib64' >> $COMMON_INSTALL_PREFIX/setup.sh &&\
    echo 'export LD_LIBRARY_PATH=$COMMON_INSTALL_PREFIX/lib64:$COMMON_BUILD_PREFIX/lib:$LD_LIBRARY_PATH' >> $COMMON_INSTALL_PREFIX/setup.sh
