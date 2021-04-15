## Assert-Objectscript


Assert-Objectscriptm is a supplemental assertion library meant to enhance readability of resulting test failures.

Instead of this
```
AssertEquals:objectA== objectB was '6@%Library.DynamicObject'
```

you will get this
```
AssertFailure:
    Expected:
%DynamicObject(value: Foo)
    to be equal to:
%DynamicObject(value: Bar)
```

## Basic Usage

Assert-Objectscript uses a builder pattern to construct an assertion. It consists of these steps
1. Construct the assertion builder
2. Configure the assertion builder
3. Finish with an assertion

Each assert follows this in the fashion of ``assert...thatActual...is...``

### Construction
Since Assert-Objectscript relies on the basic ObjectScript asserts and the ``AssertFailureViaMacro`` function, a test context with the ``%UnitTest.TestCase`` class must be available. So you will start
any assertion like this.

```scala
set builder = ##class(hbt.utility.testing.AssertBuilder).AssertOnContext($THIS)
```

From there on, you have the choice between an assert on on object or array.

```scala
set arrayAssertBuilder = builder.ThatActualObject(object)
set objectAssertBuilder = builder.ThatActualArray(object)
```

### Configuraion
Once constructed, you can configure your assertion. For example, you could:
1. Use field by field comparison instead of object equality ``UsingFieldByFieldComparison()``
2. Ignore array order ``IgnoringOrder()``
3. Ignore a certain field during field by field comparsion ``IgnoringField("ID")``

### Assertion

Lastly, you need to finish with an assertion.
```scala
builder.ThatActualObject(actual).UsingFieldByFieldComparison().IsEqualTo(Exepcted)
```


## Available Assertions
### Dynamic Objects
### Dynamic Arrays
### Objects
### Lists


### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/HBTGmbH/assert-objectscript/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
