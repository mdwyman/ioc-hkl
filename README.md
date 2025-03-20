# Installation instructions

## Dependencies
* EPICS - https://epics.anl.gov/
* PyDevice - https://github.com/klemenv/PyDevice
* hkl - https://repo.or.cz/hkl.git

<!--
## Basic PyDevice directory structure for EPICS IOCs
/epics \
| \
├── base \
├── GUI \
├── iocs \
│   └── ioc-hkl \
├── support \
│   ├── hkl \
│   └── PyDevice \
└── util \
 \
/epics/iocs/ioc-hkl
-->

## EPICS installation
Download the EPICS base from https://epics.anl.gov/download/base/index.php and place tarball into /epics, then unpack and build. 

```bash
tar -xvzf base-7.0.8.tar.gz
mv base-7.0.8 base
cd base
make
```

## hkl installation
hkl - https://repo.or.cz/hkl.git

```bash
cd /epics/support
git clone https://repo.or.cz/hkl.git
git checkout tags/v5.0.0.3357 # DELETE, UPDATE TO NEWEST
cd hkl
```

```bash
sudo apt install gtk-doc-tools autoconf libgtkmm-3.0-dev libyaml-dev gettext autopoint gobject-introspection libtool autoconf-archive debhelper gnuplot-nox gobject-introspection gtk-doc-tools libbullet-dev libg3d-dev libg3d-plugins libgirepository1.0-dev libgl-dev libgsl-dev libgtk-3-dev libgtkglext1-dev libhdf5-dev python3-gi python3-pip elpa-htmlize dvipng libhdf5-dev povray asymptote libhdf5-dev libcglm-dev libinih-dev
```

```bash
./autogen
./configure --enable-introspection --disable-binoculars
make
sudo make install
```

If running hkl outside of this IOC, you will need to set the following environmental variables in your shell/bashrc:
```bash
export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0 
export LD_LIBRARY_PATH=LD_LIBRARY_PATH:/usr/local/lib
```

## IOC installation
Place this repo in /epics/iocs/
```bash
cd /epics/iocs
git clone https://github.com/ornl-hkl-projects/ioc-hkl.git
cd ioc-hkl
make
```

## Python
Confirm your default Python installation 
```bash
which python3
```
This should show: /usr/bin/python3


## To run 
```bash
cd /epics/iocs/PyDevice/iocBoot/iocpydev
./st.cmd
```

## To test communication and PV update
in epics shell: pydev("hklApp.test()") \
in epics shell: pydev("hklApp.get\_pseudoaxes()") \
in bash: caget TAS:hb3:in:pseudoaxesh 


# Compatibility table
| SPEC        | Bluesky hklpy                          | description                                                               | EPICS hkl                                                                                                                                                         |
|-------------|----------------------------------------|---------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| –           | select_diffractometer()                | Select the default diffractometer.                                        | switch_geom()                                                                                                                                                     |
| pa          | pa()                                   | Report (full) diffractometer settings. (pa: print all)                    | get_info() MORE NEEDED - report PV list in a shell (something like this) attach to a button in ioc, or sseq (string sequence, for executing commands in sequence) |
| wh          | wh()                                   | Report (brief) diffractometer settings. (wh: where)                       | ^ what's the difference? NEEDED                                                                                                                                   |
| br h k l    | d_object.move((h, k, l))               | (command line) Move motors of diffractometer d_object to the given h,k,l  | Done by changing field values in ioc, could also use sseq, c                                                                                                      |
| br h k l    | yield from bps.mv(d_object, (h, k, l)) | (bluesky plan) Move motors of diffractometer d_object to the given h,k,l  | Done by changing field values in ioc                                                                                                                              |
| ca h k l    | cahkl()                                | Prints calculated motor settings for the given h,k,l                      | get_axes() [are settings==positions?]                                                                                                                             |
| or_swap     | or_swap()                              | Exchange primary & secondary orientation reflections.                     | NEEDED                                                                                                                                                            |
| or0         | setor()                                | Define a crystal reflection and its motor positions.                      | add_reflection1()                                                                                                                                                 |
| or1         | setor()                                | Define a crystal reflection and its motor positions.                      | add_reflection2()                                                                                                                                                 |
| reflex      | affine()                               | Refinement of lattice parameters from list of 3 or more reflections       | Refine relfections are treated separately from bussing-levy reflections in hkl ioc, 2 different lists                                                             |
| reflex_beg  | not necessary                          | Initializes the reflections file                                          | NEEDED?                                                                                                                                                           |
| reflex_end  | not necessary                          | Closes the reflections file                                               | NEEDED?                                                                                                                                                           |
| setlat      | update_sample()                        | Update current sample lattice.                                            | handled with value fields in the ioc                                                                                                                              |
| setmode     | mode()                                 | Set the diffractometer mode for the forward() computation.                | within backward()                                                                                                                                                 |
| –           | show_constraints()                     | Show the current set of constraints (cut points).                         | NEEDED                                                                                                                                                            |
| cuts        | apply_constraints()                    | Add constraints to the diffractometer forward() computation.              | within backward()                                                                                                                                                 |
| freeze      | apply_constraints()                    | Hold an axis constant during the diffractometer forward() computation.    | within backward()                                                                                                                                                 |
| unfreeze    | undo_last_constraints()                | Undo the most-recent constraints applied.                                 | NEEDED                                                                                                                                                            |
| –           | reset_constraints()                    | Reset the diffractometer constraints to defaults.                         | NOT NEEDED, constraints selected in the ioc                                                                                                                       |
| –           | calc_UB()                              | Compute the UB matrix with two reflections.                               | compute_UB()                                                                                                                                                      |
| –           | change_sample()                        | Pick a known sample to be the current selection.                          | ioc hkl currently doesn’t handle more than one sample, reset ioc to start on new sample                                                                           |
| –           | list_samples()                         | List all defined crystal samples.                                         | ioc hkl currently doesn’t handle more than one sample, reset ioc to start on new sample                                                                           |
| –           | new_sample()                           | Define a new crystal sample.                                              | ioc hkl currently doesn’t handle more than one sample, reset ioc to start on new sample                                                                           |
| setaz h k l | TODO:                                  | Set the azimuthal reference vector to the given h,k,l                     | NEEDED                                                                                                                                                            |
| setsector   | TODO:                                  | Select a sector.                                                          | ?                                                                                                                                                                 |
| cz          | TODO:                                  | Calculate zone from two reflections                                       | ?                                                                                                                                                                 |
| mz          | TODO:                                  | Move zone                                                                 | ?                                                                                                                                                                 |
| pl          | TODO:                                  | Set the scattering plane                                                  | NEEDED                                                                                                                                                            |
| sz          | TODO:                                  | Set zone                                                                  | ?                                                                                                                                                                 |

