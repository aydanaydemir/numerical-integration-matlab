# Numerical Integration Analysis in MATLAB

This repository contains a MATLAB script that evaluates the numerical integration of the function $f(x) = x^2 + \sin(5x)$ on the interval $[0, 5]$. 

### 📌 Methods Implemented
* Left-Endpoint Rectangle Rule
* Right-Endpoint Rectangle Rule
* Midpoint Rectangle Rule
* Trapezoidal Rule

---

### 📐 Geometric Visualisation (n = 5)
To understand how each numerical method approximates the area under the curve, the script generates geometric visualisations for a small number of subintervals ($n=5$).

**1. Left-Endpoint Rectangle Rule:**
This method approximates the integral by constructing rectangles where the height is determined by the function's value at the left edge of each subinterval.

<img width="648" height="657" alt="left_endpoint_rectangle" src="https://github.com/user-attachments/assets/3034553e-67f4-4968-9f53-ed6865a460db" />

**2. Trapezoidal Rule:**
This method uses trapezoids instead of rectangles, connecting the function values at both the left and right endpoints of each subinterval, which generally provides a better fit to the curve.

<img width="648" height="657" alt="trapezoidal_rule" src="https://github.com/user-attachments/assets/c16cc15f-e2ab-4714-8e70-aa7dd630aab3" />

---

### 📊 Error and Convergence Analysis
The project evaluates the accuracy of each method across different subinterval sizes ($n = 10, 50, 100, 1000$).

**3. Error Convergence Comparison (Log-Log Scale):**
This plot demonstrates the convergence order of the methods. As seen below, the Midpoint and Trapezoidal rules exhibit second-order convergence ($O(h^2)$), while the Left- and Right-Endpoint rules show first-order convergence ($O(h)$).

<img width="800" height="579" alt="error_convergence_comp" src="https://github.com/user-attachments/assets/320d3746-466b-4476-a867-b293c6bb858e" />

**4. Convergence to the Exact Value:**
This graph illustrates how the numerical approximations from all four methods converge towards the exact analytical integral value (approximately $41.668$) as the number of subintervals increases.

<img width="956" height="630" alt="convergence" src="https://github.com/user-attachments/assets/36bffd07-8daa-4c26-bb84-b9c136f389b1" />

---

### 🚀 How to Run
Simply open `numerical_integration.m` in MATLAB and run the script. It will output the exact analytical value, a numerical comparison table in the command window, and generate all the visual plots automatically.
