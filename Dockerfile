FROM dev_ext as dev_HEP
COPY --from=dev_ext $COMMON_BUILD_PREFIX $COMMON_BUILD_PREFIX
COPY --from=dev_ext $COMMON_INSTALL_PREFIX $COMMON_INSTALL_PREFIX

# CLHEP
RUN source $COMMON_INSTALL_PREFIX/usr/setup.sh && \
    cd $COMMON_BUILD_PREFIX && \
    git clone https://gitlab.cern.ch/CLHEP/CLHEP.git source &&\
    mkdir build &&\
    cd build &&\
    cmake -DCMAKE_INSTALL_PREFIX=$COMMON_INSTALL_PREFIX ../source &&\
    make -j3 &&\
    make install && \
    cd $COMMON_BUILD_PREFIX && \
    rm -rf $COMMON_BUILD_PREFIX/* &&\
    echo '# CLHEP Specific Paths' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
    echo 'export CLHEP_BASE_DIR=$COMMON_INSTALL_PREFIX' >> $COMMON_INSTALL_PREFIX/usr/setup.sh && \
    echo 'export CLHEP_INCLUDE_DIR=$COMMON_INSTALL_PREFIX/include' >> $COMMON_INSTALL_PREFIX/usr/setup.sh && \
    echo 'export CLHEP_LIBRARY=$COMMON_INSTALL_PREFIX/lib' >> $COMMON_INSTALL_PREFIX/usr/setup.sh && \
    echo 'export CLHEP_LIB_DIR=$COMMON_INSTALL_PREFIX/lib' >> $COMMON_INSTALL_PREFIX/usr/setup.sh && \
# GEANT4 10.*
ENV G4_VER=10.05.p01
RUN source $COMMON_INSTALL_PREFIX/setup.sh && \
    cd $COMMON_BUILD_PREFIX && \
    wget http://geant4.cern.ch/support/source/geant4.${G4_VER}.tar.gz && \
    tar -xzf geant4.10.*.tar.gz && \
    mkdir -p geant_build &&\
    cd geant_build && \
    cmake -DCMAKE_INSTALL_PREFIX=$COMMON_INSTALL_PREFIX \
          -DGEANT4_USE_SYSTEM_CLHEP=ON \
          -DGEANT4_INSTALL_DATA=ON \
          #-DGEANT4_USE_QT=ON
          -DGEANT4_USE_OPENGL_X11=ON \
          -DGEANT4_USE_RAYTRACER_X11=ON \
          -DGEANT4_USE_GDML=ON \
          ../geant4.10* && \
    make -j3 install && \
    cd $COMMON_BUILD_PREFIX && \
    rm -rf $COMMON_BUILD_PREFIX/* &&\
    echo '# GEANT4 Specific Paths' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
    echo 'source $COMMON_INSTALL_PREFIX/bin/geant4.sh' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
    echo 'export GEANT4_INCLUDE=$COMMON_INSTALL_PREFIX/include/Geant4' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
    echo 'export GEANT4_INSTALL_BIN=$COMMON_INSTALL_PREFIX/bin' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
    echo 'export GEANT4_LIBRARY=$COMMON_INSTALL_PREFIX/lib64' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
    echo 'export GEANT4_LIBRARY_DIR=$COMMON_INSTALL_PREFIX/lib64' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
    echo 'export LD_LIBRARY_PATH=$COMMON_INSTALL_PREFIX/lib64:$COMMON_BUILD_PREFIX/lib:$LD_LIBRARY_PATH' >> $COMMON_INSTALL_PREFIX/usr/setup.sh &&\
