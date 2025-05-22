<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Power BI Dashboard Development Guide</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        .container {
            max-width: 900px;
            margin: 20px auto;
            background-color: #fff;
            padding: 25px 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h1, h2, h3 {
            color: #005A9C; /* A Power BI-like blue */
        }
        h1 {
            text-align: center;
            border-bottom: 2px solid #005A9C;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        h2 {
            margin-top: 35px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 8px;
        }
        h3 {
            margin-top: 25px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            margin-bottom: 20px;
            font-size: 0.95em;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px 12px;
            text-align: left;
            vertical-align: top;
        }
        th {
            background-color: #f0f8ff; /* Light Alice Blue */
            font-weight: bold;
        }
        pre {
            background-color: #2d2d2d; /* Dark background for code */
            color: #f8f8f2; /* Light text for code */
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            font-family: 'Consolas', 'Monaco', 'Courier New', Courier, monospace;
            font-size: 0.9em;
            line-height: 1.4;
        }
        code {
            font-family: 'Consolas', 'Monaco', 'Courier New', Courier, monospace;
            background-color: #eef2f7; /* Light background for inline code */
            padding: 2px 5px;
            border-radius: 3px;
            font-size: 0.9em;
        }
        pre code {
            background-color: transparent; /* No double background for code in pre */
            padding: 0;
            font-size: 1em; /* Reset font size within pre */
        }
        .instructor-info, .data-link {
            text-align: center;
            margin-bottom: 15px;
            font-size: 1.05em;
        }
        .note {
            font-style: italic;
            color: #555;
            background-color: #fff9e6; /* Light yellow background for note */
            padding: 10px;
            border-left: 4px solid #ffc107; /* Amber accent */
            margin: 15px 0;
        }
        ul, ol {
            margin-left: 0; /* Align with text */
            padding-left: 25px; /* Indentation for bullets/numbers */
        }
        li {
            margin-bottom: 8px;
        }
        ul ul, ol ul, ul ol, ol ol {
            margin-top: 5px;
            margin-bottom: 5px;
        }
        hr {
            border: 0;
            height: 1px;
            background-color: #ccc;
            margin: 30px 0;
        }
        a {
            color: #0078D4; /* Standard link blue */
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .dax-measure-name {
            font-weight: bold;
        }
        .visual-number {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Power BI Dashboard Development: Step-by-Step</h1>

        <div class="instructor-info">
            <p><strong>Instructor:</strong> Dr Sandun Dassanayake
            (<a href="https://www.linkedin.com/in/sandun-dassanayake/" target="_blank">LinkedIn Profile</a>)</p>
        </div>

        <div class="data-link">
            <p><strong>Data File:</strong> <a href="https://mega.nz/file/LZFTmAJb#fRk_YCbrtxSxmwv4JaP9LNteeVoig1_Pkbz4FE6IwQo" target="_blank">Global Sales Data.csv</a></p>
        </div>

        <p class="note">Below is a <strong>hands-on recipe</strong>—from loading the CSV to building ten insight-rich visuals—written for <strong>Power BI Desktop (May 2025 release or later)</strong>.
        Follow the steps in order; each visual builds on measures or columns you create earlier.</p>

        <hr>

        <h2>0. Load &amp; prepare the data (one-time)</h2>

        <ol>
            <li><strong>Home &#9658; Get Data &#9658; Text/CSV</strong> &rarr; select <code>Global Sales Data.csv</code>.</li>
            <li>
                <strong>Transform Data</strong>
                <ul>
                    <li>
                        <strong>Change types</strong>
                        <ul>
                            <li><code>TransactionDate</code>, <code>DeliveredDate</code>, <code>LastGRNDate</code> &rarr; <em>Date</em></li>
                            <li><code>Quantity</code>, <code>Discount</code> &rarr; <em>Decimal Number</em></li>
                            <li><code>Price</code>, <code>Sales</code> &rarr; <em>Whole Number</em> (or <em>Fixed Decimal</em> if you prefer currency formatting).</li>
                        </ul>
                    </li>
                    <li>
                        <strong>Add a “DeliveryDays” column</strong>
                        <ul>
                            <li>Transform &#9658; Custom Column
<pre><code class="language-powerquery">
= Duration.Days([DeliveredDate] - [TransactionDate])
</code></pre>
                            </li>
                            <li>Change its type to <em>Whole Number</em>; rename <strong>Delivery Days</strong>.</li>
                        </ul>
                    </li>
                    <li>Close &amp; Apply.</li>
                </ul>
            </li>
            <li>
                <strong>Create a proper Date table</strong> (Model view &#9658; Table tools &#9658; New table):
<pre><code class="language-dax">
DimDate =
VAR MinDate = MIN ( 'Global Sales Data'[TransactionDate] )
VAR MaxDate = MAX ( 'Global Sales Data'[TransactionDate] )
RETURN
CALENDAR ( MinDate, MaxDate )
</code></pre>
                <ul>
                    <li>Mark it as a <em>Date table</em> (Table tools &#9658; Mark as date table &#9658; choose <code>[Date]</code>).</li>
                </ul>
            </li>
            <li>
                <strong>Relationships</strong>
                <table>
                    <thead>
                        <tr>
                            <th>From (one)</th>
                            <th>To (many)</th>
                            <th>Cardinality</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><code>DimDate[Date]</code></td>
                            <td><code>Global Sales Data[TransactionDate]</code></td>
                            <td>1 : *</td>
                        </tr>
                    </tbody>
                </table>
            </li>
        </ol>

        <hr>

        <h2>1. Reusable DAX measures</h2>
        <p>Create these in <em>Modeling &#9658; New Measure</em> and keep them in a <strong>Measures</strong> display folder:</p>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Formula</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong class="dax-measure-name">Total Sales</strong></td>
                    <td><code>Total Sales := SUM ( 'Global Sales Data'[Sales] )</code></td>
                </tr>
                <tr>
                    <td><strong class="dax-measure-name">Total Qty</strong></td>
                    <td><code>Total Qty   := SUM ( 'Global Sales Data'[Quantity] )</code></td>
                </tr>
                <tr>
                    <td><strong class="dax-measure-name">Total Discount</strong></td>
                    <td><code>Total Discount := SUM ( 'Global Sales Data'[Discount] )</code></td>
                </tr>
                <tr>
                    <td><strong class="dax-measure-name">Avg Price</strong></td>
                    <td><code>Avg Price := AVERAGE ( 'Global Sales Data'[Price] )</code></td>
                </tr>
                <tr>
                    <td><strong class="dax-measure-name">YoY Sales &Delta; %</strong></td>
                    <td><code>YoY Sales Δ % := DIVIDE ( [Total Sales] - CALCULATE ( [Total Sales], SAMEPERIODLASTYEAR ( DimDate[Date] ) ), CALCULATE ( [Total Sales], SAMEPERIODLASTYEAR ( DimDate[Date] ) ) )</code></td>
                </tr>
            </tbody>
        </table>

        <hr>

        <h2>2. Ten insight-driven visuals</h2>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Visual &amp; insight</th>
                    <th>Step-by-step</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong class="visual-number">1</strong></td>
                    <td><strong>Sales Trend (Line chart)</strong> – <em>Are revenues rising? Seasonal dips?</em></td>
                    <td>
                        1. Insert &#9658; Line chart.<br>
                        2. X-axis &rarr; <code>DimDate[Date]</code>; Y-axis &rarr; <em>Total Sales</em>.<br>
                        3. Format &#9658; Data type &rarr; Continuous; turn on <strong>Data labels</strong>.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">2</strong></td>
                    <td><strong>Monthly Seasonality (Area chart)</strong> – <em>Which months peak?</em></td>
                    <td>
                        1. Duplicate line chart or add Area chart.<br>
                        2. X-axis &rarr; <code>'Global Sales Data'[Month]</code> (set sorting to Jan &rarr; Dec).<br>
                        3. Y-axis &rarr; <em>Total Sales</em>.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">3</strong></td>
                    <td><strong>Sales by Product Category (Clustered bar)</strong> – <em>Top earners?</em></td>
                    <td>
                        1. Insert &#9658; Clustered bar chart.<br>
                        2. Y-axis &rarr; <code>Product</code>; X-axis &rarr; <em>Total Sales</em>.<br>
                        3. Sort descending; optionally add <strong>Data bars</strong> in visual’s formatting pane.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">4</strong></td>
                    <td><strong>Sales Contribution by Quarter (Donut)</strong> – <em>Strategic planning by quarter.</em></td>
                    <td>
                        1. Insert &#9658; Donut chart.<br>
                        2. Legend &rarr; <code>Quarter</code>; Values &rarr; <em>Total Sales</em>.<br>
                        3. Turn on <em>Detail labels</em> &#9658; % of total.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">5</strong></td>
                    <td><strong>Sales by Customer Grade (100 % stacked column)</strong> – <em>Who drives revenue?</em></td>
                    <td>
                        1. Insert &#9658; 100 % stacked column.<br>
                        2. Axis &rarr; <code>Customer Grade</code>; Value &rarr; <em>Total Sales</em>.<br>
                        3. Tooltip + Legend uses same field for clean view.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">6</strong></td>
                    <td><strong>Geographical Sales (Filled map)</strong> – <em>Regional focus.</em></td>
                    <td>
                        1. Insert &#9658; Map (or Azure Maps).<br>
                        2. Location &rarr; <code>Location</code> (field well auto-detects cities).<br>
                        3. Size &rarr; <em>Total Sales</em>; Color saturation &rarr; <em>Total Sales</em>.<br>
                        4. Enable Map &#9658; Heat map layer for intensity view.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">7</strong></td>
                    <td><strong>Discount vs Quantity (Scatter)</strong> – <em>Does discounting move stock?</em></td>
                    <td>
                        1. Insert &#9658; Scatter chart.<br>
                        2. X-axis &rarr; <em>Total Discount</em>; Y-axis &rarr; <em>Total Qty</em>; Size &rarr; <em>Total Sales</em>.<br>
                        3. Legend &rarr; <code>Product</code> (optional to highlight categories).<br>
                        4. Turn on <em>Play axis</em> with <code>DimDate[Year]</code> to see progression.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">8</strong></td>
                    <td><strong>Sales Heat-map (Matrix)</strong> – <em>Month &times; Product performance.</em></td>
                    <td>
                        1. Insert &#9658; Matrix.<br>
                        2. Rows &rarr; <code>Month</code>; Columns &rarr; <code>Product</code>; Values &rarr; <em>Total Sales</em>.<br>
                        3. Format &#9658; Conditional formatting &#9658; Background color (Diverging) to turn the matrix into a heat-map.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">9</strong></td>
                    <td><strong>Delivery Days Distribution (Histogram or Box plot)</strong> – <em>Logistics efficiency.</em></td>
                    <td>
                        <em>Option A – Histogram</em> (custom visual):<br>
                        1. Get more visuals &#9658; “Histogram by xViz”.<br>
                        2. X-axis &rarr; <code>Delivery Days</code>.<br>
                        3. Values &rarr; Count of <code>Transaction ID</code> (or <code>Quantity</code>).<br>
                        <em>Option B – Box &amp; whisker (Deneb custom visual)</em> for outliers.
                    </td>
                </tr>
                <tr>
                    <td><strong class="visual-number">10</strong></td>
                    <td><strong>Price vs Quantity by Product (Bubble)</strong> – <em>Pricing power.</em></td>
                    <td>
                        1. Insert &#9658; Scatter chart.<br>
                        2. X-axis &rarr; <em>Avg Price</em>; Y-axis &rarr; <em>Total Qty</em>; Size &rarr; <em>Total Sales</em>; Legend &rarr; <code>Product</code>.<br>
                        3. Add a <em>Trend line</em> (Analytics pane) to spot correlation.
                    </td>
                </tr>
            </tbody>
        </table>

        <hr>

        <h2>3. Finishing touches</h2>
        <table>
            <thead>
                <tr>
                    <th>Task</th>
                    <th>How</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Create a slicer panel</strong></td>
                    <td>Insert &#9658; Slicer &rarr; <code>DimDate[Year]</code>; duplicate for <code>Month</code>/<code>Customer Grade</code>; group and hide in a bookmark-toggle “Filters” pane.</td>
                </tr>
                <tr>
                    <td><strong>Theme &amp; colors</strong></td>
                    <td>View &#9658; Themes &#9658; Browse for themes &rarr; import a corporate JSON or pick “Color blind safe”.</td>
                </tr>
                <tr>
                    <td><strong>Tooltips</strong></td>
                    <td>Report &#9658; + New page &rarr; Tooltip size 320 &times; 240; add key measures; Page information &#9658; Tooltip on = On.</td>
                </tr>
                <tr>
                    <td><strong>Performance</strong></td>
                    <td>Modeling &#9658; Manage columns &rarr; hide unused columns; reduce numeric precision to currency; disable Auto-date/time.</td>
                </tr>
                <tr>
                    <td><strong>Publish &amp; schedule</strong></td>
                    <td>File &#9658; Publish &#9658; My Workspace (or deployment pipeline); Dataset settings &#9658; Refresh &#9658; Add gateway / schedule.</td>
                </tr>
            </tbody>
        </table>

        <hr>

        <h3>What you’ll learn from these visuals</h3>
        <ul>
            <li><strong>#1 &amp; #2</strong> reveal macro growth and seasonality.</li>
            <li><strong>#3 &amp; #4</strong> spotlight product mix and quarterly targets.</li>
            <li><strong>#5</strong> quantifies loyalty tiers.</li>
            <li><strong>#6</strong> pinpoints geographic hot-spots.</li>
            <li><strong>#7</strong> tests discount strategy effectiveness.</li>
            <li><strong>#8</strong> surfaces month-by-category micro-trends.</li>
            <li><strong>#9</strong> flags supply-chain delays.</li>
            <li><strong>#10</strong> evaluates price elasticity.</li>
        </ul>

        <p>Re-creating them in the order above ensures every measure or calculated column is ready when a later visual needs it. Happy building—and may your dashboards turn data into decisions!</p>

    </div>
</body>
</html>
