Battery Data Structuring Script
This repository contains MATLAB code for converting raw battery cycling data from Battery Management Systems (BMS) into a structured format similar to the NASA battery dataset commonly used by the battery research community.
This script was used in the paper titled:

"Computational Micromechanics and Machine Learning-Informed Design of Composite Carbon Fiber-Based Structural Battery for Multifunctional Performance Prediction," published in ACS Applied Materials & Interfaces.

It is a straightforward and well-documented code that processes BMS data into categorized charging, discharging, and resting steps, making it suitable for further analysis or machine learning applications.

Features
Reads multiple sheets from an Excel file containing raw BMS data.

Combines and processes voltage, current, and capacity data.

Classifies data into charging, discharging, and resting steps.

Organizes the data into a MATLAB structure for easy use.

Adjusts time profiles for each cycle, making data normalization easier.

Saves the processed data into a .mat file.

Implementation Details
Prerequisites
MATLAB installed on your system.

Excel data file in the expected format (example: SPE40_0.1C.xlsx).

Example Dataset
The script uses a file named SPE40_0.1C.xlsx as an example.

Make sure to adjust the file name to your own dataset if needed.

Usage
Steps to Run the Code
Open the MATLAB script.

Specify the name of your Excel file.

Run the script to process and structure the battery cycling data.

The structured data will be saved as a .mat file (e.g., SPE40_0p1C.mat).

The script is organized into clear sections and commented for easy understanding.

Key Steps Performed by the Code
Data Loading:

Loads all sheets from the specified Excel file.

Data Processing:

Combines data from different sheets into a single matrix.

Cycle Classification:

Separates data into 'charging' and 'discharging' cycles based on current direction.

Ignores rest periods based on a small current threshold.

Data Structuring:

Organizes each cycle's time, voltage, current, and capacity data into a MATLAB structure.

Time Normalization:

Adjusts test time in each cycle to start from zero, aiding further processing like machine learning.

Saving:

Saves the structured data into a .mat file for future use.

Output
Structured Data
Charging and discharging cycles separately stored.

Each cycle contains time, voltage, current, and capacity fields.

Saved output example: SPE40_0p1C.mat

Typical Applications
Data preprocessing for battery aging analysis.

Preparing datasets for machine learning models (e.g., battery capacity forecasting).

Simplified visualization and further analysis.

Citation
If you use this code in your research or publications, please cite the associated work:

M. A. Raja, W. Kim, W. Kim, S. H. Lim, and S. S. Kim,
“Computational Micromechanics and Machine Learning-Informed Design of Composite Carbon Fiber-Based Structural Battery for Multifunctional Performance Prediction,”
ACS Applied Materials & Interfaces, vol. 17, no. 13, pp. 20125–20137, Feb. 2025. doi:10.1021/acsami.4c19073

License
This project is licensed under the MIT License. See the LICENSE file for more details.

