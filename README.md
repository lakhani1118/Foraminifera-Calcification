# **Foraminifera-Calcification**
Code repository for Lakhani et al. submitted to Marine Micropaleontology

## **Directories:**

**Data** -- stores data output from Matlab scripts in main directory, keeps main directory clear of clutter

**Functions** -- contains functions that are useful to running code, keeps main directory clear of clutter, added to path in most scripts

**Make d18O field** -- contains the script and output for creating a field of predicted d18O of calcite from World Ocean Atlas 0.25 degree temperature and LeGrande and Schmidt gridded d18Osw output

**MARGO** -- contains subset of data that is from MARGO

**Thermocline Percent** -- stores data for the Thermocline Percent analysis that is derived from World Ocean Atlas temperature field, called from TP scripts

## **Figures:**
To run Figure 1 code: Run DatabaseImporter.m, then run Run_global_ACD.m for either Holocene=1 or Holocene=0, then run Figure 1.m with the same Holocene value

To run Figure 2 code: Run DatabaseImporter.m, then run Run_global_ACD.m for either Holocene=1 or Holocene=0, then run Run_local_ACD.m for Holocene=1 AND Holocene=0, then run Figure 2.m with the Holocene value from Run_global_ACD.m

To run Figure 3 code: Run DatabaseImporter.m, then run Run_local_ACD.m for Holocene=1 AND Holocene=0, then run Figure 3.m for Holocene=1 AND Holocene=0

To run Figure 4 code: Run DatabaseImporter.m, then run Run_global_TP.m for either Holocene=1 or Holocene=0, then run Run_local_ACD.m for Holocene=1 AND Holocene=0, then run Figure4.m with the Holocene value from Run_global_TP.m

To run Figure 5 code: Run DatabaseImporter.m, then run Run_local_ACD.m for both Holocene=1 and Holocene=0, then run Run_global_ACD.m for Holocene=0, then run Constant_Percent.m for either Holocene=1 or Holocene=0, then run Figure 5.m section 1, then run Figure 5.m section 2
