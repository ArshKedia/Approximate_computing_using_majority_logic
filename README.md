# Approximate_computing_using_majority_logic
## Design and Analysis of Majority Logic based Approximate Adders and Multipliers

# Aim
1. A new 2-bit MLAFA (Majority Logic Approximate Full Adder) is proposed based on truth table reduction; it can be used for multi-bit approximate adder design;<br/>

2. A 2 x 2 MLAM (Majority Logic Approximate Multiplier) is proposed and complement bits are introduced;<br/>

3. A novel analysis for selecting complement bits is presented;<br/>

4. MLACs (Majority Logic Approximate Compressors) based on K-Map simplification and 1-bit MLAFAs are proposed;<br/>

5. Exact as well as approximate pipelined reduction circuits for 4 x 4 and 8 x 8 MLAMs are proposed.<br/>



# Files present
1. Schematic - Schematic of all the adders and multipliers in LTspice. <br/>
2. Verilog - Verilog codes of all adders and multipliers proposed. <br/>
3. Input - Image and hex file of the image used in image processing.<br/>
4. Presentation - .ppt file of the presentation slides.<br/>


# Conclusions
1. This paper has presented a design, analysis and evaluation of majority logic based approximate adders and approximate multipliers. The following conclusions can be drawn:<br/>
2. By combining the proposed 1-bit MLAFA and the existing 1-bit MLAFA, multi-bit MLAFAs can be designed with a relatively large error. The proposed MLAFA33 designed by truth table reduction can provide the solution for improving accuracy. For 8-bit adders, MLAFA1212-1233 (with a reduction of 58 percent in majority gates as well as 50 percent in delay) and MLAFA1212-3333 (with a reduction of 50 percent in majority gates as well as 50 percent in delay) are superior to other designs.<br/>
3. Based on the proposed 2 x 2 MLAM, we can selectively design multi-bit multipliers by adding the complement bits. From the presented theoretical analysis, for a 4 x 4 multiplier, when p changes from 3 to 4, the NMED increases sharply; for an 8 x 8 multiplier, when p is smaller than 10, the NMED increases slowly but when p is larger than 10, the NMED increases rapidly. So p = 3 and p = 10 are the best choices for the 4 x 4 multiplier and the 8 x 8 multiplier, respectively.<br/>
4. MLAC22-2 and MLAC12-1 show the best overall performance among these MLACs based on MLAFAs. Compared with the exact design, the proposed designs save 67 percent of majority gates, 50 percent of inverters, 50 percent of delay and 67 percent of carry chain. Although MLAC4 requires two additional 3-input majority gates, MLAC4 only has 2 outputs, which is likely to reduce the approximate operation in the PPR circuitry. The MLAC4 based 8 x 8 multiplier using 2 x 2 multipliers (p = 10) reduces the number of majority gates by up to 48 percent, the number of inverters by up to 67 percent, and the delay by up to 47 percent compared to the exact counterpart, achieving a significant decrease of hardware without incurring in large errors.<br/>




# Contributors
1. Arsh Kedia (MT2022503)
2. Lokesh Maji(MT2022509)
3. Rohit Raj  (MT2022517)
4. Siddhant Nayak (MT2022518)
