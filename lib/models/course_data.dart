// courses_data.dart

final List<Map<String, dynamic>> courses = [
  {
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/Pandas_logo.svg/300px-Pandas_logo.svg.png',
    'tags': ['All level'],
    'title': 'pandas',
    'description':
        'A software library written for the Python programming language for data manipulation and analysis',
    'rating': 4.0,
    'duration': 13,
    'lectures': 15,
    'category': 'Web Design',
    'post': {
      'title': 'Sketch from A to Z: for app designer',
      'description': 'Proposal indulged no do sociable he throwing settling.',
      'content': [
        {
          'type': 'text',
          'data':
              'In this tutorial, we will learn how to create a Python file, open it, import pandas, create a simple dataframe, and display it using `pd.head()`.'
        },
        {
          'type': 'code',
          'data':
              'import pandas as pd\n\n# Create a simple dataframe\ndata = {\'Name\': [\'John\', \'Anna\', \'Peter\', \'Linda\'], \'Age\': [28, 22, 34, 42]}\ndf = pd.DataFrame(data)\n\n# Display the dataframe\nprint(df.head())'
        },
        {
          'type': 'text',
          'data':
              'This is a simple example of how to use pandas to create and display a dataframe.'
        },
      ],
    },
  },
  {
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/NumPy_logo_2020.svg/120px-NumPy_logo_2020.svg.png',
    'tags': ['Beginner', 'Data Science'],
    'title': 'NumPy Essentials: Mastering Numerical Computing in Python',
    'description':
        'Learn the fundamentals of NumPy, the core library for numerical computing in Python, and unlock the power of arrays and matrices.',
    'rating': 4.7,
    'duration': 8,
    'lectures': 10,
    'category': 'Data Science',
    'post': {
      'title': 'NumPy Essentials: Mastering Numerical Computing in Python',
      'description':
          'Learn the fundamentals of NumPy, the core library for numerical computing in Python, and unlock the power of arrays and matrices.',
      'content': [
        {
          'type': 'text',
          'data':
              'In this tutorial, we will explore the basics of NumPy, including how to create arrays, perform mathematical operations, and manipulate data efficiently.'
        },
        {
          'type': 'code',
          'data':
              'import numpy as np\n\n# Create a simple array\narr = np.array([1, 2, 3, 4, 5])\nprint("Array:", arr)\n\n# Perform basic mathematical operations\nprint("Sum:", np.sum(arr))\nprint("Mean:", np.mean(arr))\nprint("Max:", np.max(arr))'
        },
        {
          'type': 'text',
          'data':
              'This is a basic example of how to create and manipulate arrays using NumPy. NumPy arrays are more efficient than Python lists for numerical computations.'
        },
        {
          'type': 'code',
          'data':
              '# Create a 2D array (matrix)\nmatrix = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])\nprint("Matrix:\\n", matrix)\n\n# Perform matrix operations\nprint("Transpose:\\n", matrix.T)\nprint("Matrix multiplication:\\n", np.dot(matrix, matrix.T))'
        },
        {
          'type': 'text',
          'data':
              'NumPy is widely used for matrix operations in data science and machine learning. Here, we created a 2D array and performed operations like transposition and matrix multiplication.'
        },
        {
          'type': 'code',
          'data':
              '# Create an array with zeros and ones\nzeros_arr = np.zeros((3, 3))\nones_arr = np.ones((2, 4))\n\nprint("Zeros array:\\n", zeros_arr)\nprint("Ones array:\\n", ones_arr)'
        },
        {
          'type': 'text',
          'data':
              'NumPy provides convenient functions like `np.zeros()` and `np.ones()` to create arrays filled with zeros or ones. These are useful for initializing data structures.'
        },
        {
          'type': 'code',
          'data':
              '# Generate random numbers\nrandom_arr = np.random.rand(3, 3)\nprint("Random array:\\n", random_arr)\n\n# Generate random integers\nrandom_ints = np.random.randint(1, 100, size=(3, 3))\nprint("Random integers:\\n", random_ints)'
        },
        {
          'type': 'text',
          'data':
              'NumPy also includes powerful random number generation capabilities. Here, we created arrays with random floating-point numbers and integers.'
        },
      ],
    },
  },
  {
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/en/thumb/5/56/Matplotlib_logo.svg/300px-Matplotlib_logo.svg.png',
    'tags': ['Beginner', 'Data Visualization'],
    'title': 'Mastering Matplotlib: Data Visualization in Python',
    'description':
        'Learn how to create stunning visualizations using Matplotlib, the most popular plotting library in Python.',
    'rating': 4.5,
    'duration': 10,
    'lectures': 12,
    'category': 'Data Science',
    'post': {
      'title': 'Mastering Matplotlib: Data Visualization in Python',
      'description':
          'Learn how to create stunning visualizations using Matplotlib, the most popular plotting library in Python.',
      'content': [
        {
          'type': 'text',
          'data':
              'In this tutorial, we will explore the basics of Matplotlib, including how to create line plots, bar charts, scatter plots, and more.'
        },
        {
          'type': 'code',
          'data':
              'import matplotlib.pyplot as plt\n\n# Create a simple line plot\nx = [1, 2, 3, 4, 5]\ny = [10, 20, 25, 30, 40]\n\nplt.plot(x, y)\nplt.title("Simple Line Plot")\nplt.xlabel("X-axis")\nplt.ylabel("Y-axis")\nplt.show()'
        },
        {
          'type': 'text',
          'data':
              'This is a basic example of how to create a line plot using Matplotlib. You can customize the plot by adding titles, labels, and more.'
        },
        {
          'type': 'code',
          'data':
              '# Create a bar chart\ncategories = ["A", "B", "C", "D"]\nvalues = [15, 20, 35, 30]\n\nplt.bar(categories, values)\nplt.title("Bar Chart Example")\nplt.xlabel("Categories")\nplt.ylabel("Values")\nplt.show()'
        },
        {
          'type': 'text',
          'data':
              'Bar charts are great for comparing categorical data. In this example, we created a bar chart to compare values across different categories.'
        },
        {
          'type': 'code',
          'data':
              '# Create a scatter plot\nx = [5, 7, 8, 7, 2, 17, 2, 9, 4, 11]\ny = [99, 86, 87, 88, 100, 86, 103, 87, 94, 78]\n\nplt.scatter(x, y)\nplt.title("Scatter Plot Example")\nplt.xlabel("X-axis")\nplt.ylabel("Y-axis")\nplt.show()'
        },
        {
          'type': 'text',
          'data':
              'Scatter plots are useful for visualizing relationships between two variables. Here, we created a scatter plot to show the relationship between X and Y values.'
        },
      ],
    },
  },
];
