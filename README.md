# 🏠 Real-estate-SQL-Analysis

This project analyzes real estate data from a website selling different types of property in India.
[Source](https://www.kaggle.com/datasets/kunjadiyarohit/flats-uncleaned-dataset/data) 

The project begins with cleaning up faulty and untidy data and then moves to data analysis.

The insights below are discovered through data exploration and analysis of the dataset.

 ## 📈 **I. General Market Trends (All Area Types)**:

- **Resale Dominates:** Most transactions are "Resale," with higher average prices than new properties.
- **High Demand for Apartments/Houses:**  Most buyers are looking for apartments or houses.
- **Low Price, Ready, Unfurnished:** The market favors lower-priced, ready-to-move-in, unfurnished properties.

 ## 📍 **II. Specific Area Analysis**:

 ### 🛋️ ***A. Super Area & Carpet Area (Focus on Residential)***:

**Similarities**:
- **High Listing Volume:** Both have the highest number of property listings, mostly "Resale."
- **Unfurnished Apartments:** Primarily offer unfurnished apartments at relatively low prices.
- **Immediate Occupancy:** Most properties are ready to move in.

**Distinctions**:
-   **Super Area** - Most Listings, Lowest Prices: Has the most listings but the lowest average prices. New properties make up a significant portion of listings.
-   **Carpet Area** - High Demand, Higher Prices: Second highest in listings and prices, indicating strong demand for usable space.

### 🏗️ ***B.  Built Area & Plot Area (Focus on Land/Industrial)***:

**Similarities**:
- **Fewer Listings, Higher Prices:** Fewer listings overall, but higher prices due to the focus on land, plots, villas, and industrial properties.
- **Limited Details:** Furnishing and status are often unspecified.

**Distinctions**:
-   **Built Area** - Industrial Focus, Extremely High Prices: Very few listings, but extremely high prices driven by industrial properties.
-   **Plot Area** - Land/Plot Only: Exclusively lists land or plots, with more listings than "Built Area."

*(Due to the nature of Built Area and Plot Area, which mostly focus on industrial areas, villas, or land/plot correlation, it is not possible for these groups)*

## 📏 **III.  General Trend (Super Area & Carpet Area)**:

-    **Lower Floors, Higher Prices:** Properties on lower floors are generally more expensive and more popular (more listings).
-    **Bigger is Better (Mostly):** Larger properties tend to be more popular and expensive.
-    **Fewer Total Floors Preferred:** Buildings with fewer total floors are generally more desirable and have higher prices.

## 🏠 **IV.  Against the General Trend (Super Area & Carpet Area)**:

-    **Delayed/Unspecified Status**: Smaller properties are more popular and less expensive.
-    **New Properties**: Smaller, new properties are more popular and less expensive.
-    **Builder Floors**: Smaller builder floor properties are more popular.
-    **Semi-Furnished**:
    Properties in taller buildings are more expensive.
    Smaller properties are more expensive.
-    **New Properties**:
    Properties in taller buildings are more popular.
    Smaller properties are more expensive.
-    **Builder Floors**: Smaller properties are more popular.
-    **Apartments, Penthouses, Showrooms**: Smaller properties are less expensive.

## 🔍 **V.  Detailed Distinctions Within Super Area & Carpet Area**:

### 🛋️ ***A.  Carpet Area (Usable Space)***:

-    **Semi-Furnished**:
     - Higher floors and smaller properties are more expensive.
     - Taller buildings generally have higher prices.
-    **Unspecified Transaction Type**: Smaller properties are more popular and less expensive.
-    **Showrooms**: Smaller properties are more popular and less expensive.
-    **Penthouses**:
     - Smaller properties are less expensive.
     - Properties in buildings with fewer floors are more popular.
     - Smaller properties are more popular.
-    **Furnished**: Smaller properties are more popular and less expensive.
-    **New & Unspecified Transaction**: Smaller properties are more popular.
-    **Unspecified Transaction**: Properties in taller buildings are more expensive.
-    **Houses, Offices, Showrooms**: Smaller properties are less expensive.
-    **Builder Floors**: Smaller properties are less expensive.

### 🏢 ***B.  Super Area (Includes Common Areas)***:

-    **Furnished**:
     - Higher floors and smaller properties are more expensive.
     - Taller buildings have a slightly higher price.
     - Smaller properties are more common in this category.
-    **Showrooms**: Higher floors are more expensive (opposite of the general trend).
-    **Most Property Types**: Smaller properties are more popular and less expensive.
-    **Unfurnished**: Properties in taller buildings are slightly more popular.
-    **Apartments, Builder Floors, Showrooms, Studios**: Properties in taller buildings are more popular.
-    **Shops**:
     - Properties in taller buildings are more expensive.
     - Smaller properties are less expensive.
-    **Showrooms, Studios**: Smaller properties are more popular.

# **🔑 Key Takeaways**:

-   The property market is complex, with general trends favoring lower floors, larger spaces (with exceptions), fewer floors in the building, and resale properties.
-   "Super Area" and "Carpet Area" dominate the residential market, with "Super Area" offering the most affordable options.
-   "Built Area" and "Plot Area" cater to a niche market with higher-priced land and industrial properties.
