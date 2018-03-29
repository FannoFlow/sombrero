# Sombrero

<img align="right" width="400" src="https://raw.githubusercontent.com/O-Boll/sombrero/master/media/sombrero_gui_screenshot.png">

Sombrero is a MATLAB application for simulating verbal information transfer in high-density crowds by combining a self-propelled particle model for pedestrian dynamics with models of information transfer.

## Background

Sombrero was mainly developed as tool for studying the perplexing phenomenon that people in dense crowds oftentimes are completely oblivious of an ongoing crowd disaster (e.g. a crowd crush) even though they may be standing just a few meters away from areas where others are dying or getting seriously injured from compression asphyxia. However, Sombrero is quite versatile and can be used to simulate pedestrians in a wide variety of different scenarios.

## Getting Started

Sombrero is distributed in the form of a MATLAB package, and should run in MATLAB 2017b or later (and probably also many of the earlier) versions. It does not require the installation of any additional toolboxes.

To get started, add the parent directory of the +sombrero directory to the MATLAB path. To run an example simulation and open it in the simulation viewer application, type the following lines into the MATLAB command window:
```
[sm, sd, sps] = sombrero.example_2
sombrero.sim_gui.launch(sm, sd, sps)
```
The example files included in the +sombrero directory are heavily commented and showcase a lot of the functionality of Sombrero.

## Author

* Olle Eriksson

## License

Sombrero is licensed under LGPL v3.0. See [LICENSE](LICENSE) for the details.

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
