Class Meeting 4 Worksheet
================

``` r
suppressPackageStartupMessages(library(tidyverse))
library(repurrrsive)
```

Resources
=========

All are from [Jenny's `purrr` tutorial](https://jennybc.github.io/purrr-tutorial/). Specifically:

-   Parallel mapping: [Jenny's "Specifying the function in map() + parallel mapping"](https://jennybc.github.io/purrr-tutorial/ls03_map-function-syntax.html#parallel_map)
-   List columns in data frames; nesting: [Jenny's "List Columns"](https://jennybc.github.io/purrr-tutorial/ls13_list-columns.html).

The all-encompassing application near the bottom of this worksheet is from [Jenny's "Sample from groups, n varies by group"](https://jennybc.github.io/purrr-tutorial/ls12_different-sized-samples.html)

Parallel Mapping
================

We're going to work with toy cases first before the more realistic data analytic tasks, because they are easier to learn.

Want to vectorize over two iterables? Use the `map2` family:

``` r
a <- c(1,2,3)
b <- c(4,5,6)
map2(a, b, function(x, y) x*y)
```

    ## [[1]]
    ## [1] 4
    ## 
    ## [[2]]
    ## [1] 10
    ## 
    ## [[3]]
    ## [1] 18

``` r
map2(a, b, ~ .x * .y)
```

    ## [[1]]
    ## [1] 4
    ## 
    ## [[2]]
    ## [1] 10
    ## 
    ## [[3]]
    ## [1] 18

``` r
map2(a, b, `*`)
```

    ## [[1]]
    ## [1] 4
    ## 
    ## [[2]]
    ## [1] 10
    ## 
    ## [[3]]
    ## [1] 18

``` r
map2_dbl(a, b, `*`)
```

    ## [1]  4 10 18

``` r
`+`(1, 2)
```

    ## [1] 3

``` r
`<-`(t, 6)
```

More than 2? Use the `pmap` family:

``` r
a <- c(1, 2, 3)
b <- c(4, 5, 6)
c <- c(7, 8, 9)
pmap(list(a, b, c), function(x, y, z) x*y*z)
```

    ## [[1]]
    ## [1] 28
    ## 
    ## [[2]]
    ## [1] 80
    ## 
    ## [[3]]
    ## [1] 162

``` r
pmap(list(a, b, c), ~ ..1 * ..2 * ..3)
```

    ## [[1]]
    ## [1] 28
    ## 
    ## [[2]]
    ## [1] 80
    ## 
    ## [[3]]
    ## [1] 162

``` r
pmap_dbl(list(a, b, c), ~ ..1 * ..2 * ..3)
```

    ## [1]  28  80 162

Your Turn
---------

Using the following two vectors...

``` r
commute <- c(10, 50, 35)
name <- c("Parveen", "Kayden", "Shawn")
```

use `map2_chr()` to come up with the following output in three ways:

``` r
str_c(name, " takes ", commute, " minutes to get to work.")
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

``` r
map2_chr(name, commute, ~ paste(.x, "takes", .y, "minutes to get to work."))
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

1.  By defining a function before feeding it into `map2()` -- call it `comm_fun`.

``` r
comm_fun <- function(s, t)
  str_c(s, " takes ", t, " minutes to get to work.")
map2_chr(name, commute, comm_fun)
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

1.  By defining a function "on the fly" within the `map2()` function.

``` r
map2_chr(name, commute, function(t, s) str_c(t, " takes ", s, " minutes to get to work."))
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

1.  By defining a formula.

``` r
map2_chr(name, commute, ~ str_c(.x, " takes ", .y, " minutes to get to work."))
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

List columns
============

What are they?
--------------

A tibble can hold a list as a column, too:

``` r
(listcol_tib <- tibble(
  a = c(1,2,3),
  b = list(1,2,3),
  c = list(sum, sqrt, str_c),
  d = list(x=1, y=sum, z=iris)
))
```

    ## # A tibble: 3 x 4
    ##       a b         c         d                     
    ##   <dbl> <list>    <list>    <list>                
    ## 1     1 <dbl [1]> <builtin> <dbl [1]>             
    ## 2     2 <dbl [1]> <builtin> <builtin>             
    ## 3     3 <dbl [1]> <fn>      <data.frame [150 × 5]>

Printing to screen doesn't reveal the contents! `str()` helps here:

``` r
str(listcol_tib)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    3 obs. of  4 variables:
    ##  $ a: num  1 2 3
    ##  $ b:List of 3
    ##   ..$ : num 1
    ##   ..$ : num 2
    ##   ..$ : num 3
    ##  $ c:List of 3
    ##   ..$ :function (..., na.rm = FALSE)  
    ##   ..$ :function (x)  
    ##   ..$ :function (..., sep = "", collapse = NULL)  
    ##  $ d:List of 3
    ##   ..$ x: num 1
    ##   ..$ y:function (..., na.rm = FALSE)  
    ##   ..$ z:'data.frame':    150 obs. of  5 variables:
    ##   .. ..$ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
    ##   .. ..$ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
    ##   .. ..$ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
    ##   .. ..$ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
    ##   .. ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

Extract a list column in the same way as a vector column:

``` r
print(listcol_tib$a)  # Vector
```

    ## [1] 1 2 3

``` r
print(listcol_tib$b)  # List
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [1] 2
    ## 
    ## [[3]]
    ## [1] 3

This is where `map()` comes in handy! Let's make a tibble using the `got_chars` data, with two columns: "name" and "aliases", where "aliases" is a list-column (remember that each character can have a number of aliases different than 1):

1.  Pipe `got_chars` into `{` with `tibble()`.
2.  Specify the columns with `purrr` mappings.

``` r
got_alias <- got_chars %>% {
  tibble(name = map_chr(., "name"),
         aliases = map(., "aliases"))
}
got_alias
```

    ## # A tibble: 30 x 2
    ##    name               aliases   
    ##    <chr>              <list>    
    ##  1 Theon Greyjoy      <chr [4]> 
    ##  2 Tyrion Lannister   <chr [11]>
    ##  3 Victarion Greyjoy  <chr [1]> 
    ##  4 Will               <chr [1]> 
    ##  5 Areo Hotah         <chr [1]> 
    ##  6 Chett              <chr [1]> 
    ##  7 Cressen            <chr [1]> 
    ##  8 Arianne Martell    <chr [1]> 
    ##  9 Daenerys Targaryen <chr [11]>
    ## 10 Davos Seaworth     <chr [5]> 
    ## # ... with 20 more rows

Write the solution down carefully -- we'll be referring to `got_alias` later.

Making: Your Turn
-----------------

Extract the aliases of Melisandre (a character from Game of Thrones) from the `got_alias` data frame we just made. Try two approaches:

Approach 1: Without piping

1.  Make a list of aliases by extracting the list column in `got_alias`.
2.  Set the names of this new list as the character names (from the other column of `got_chars`).
3.  Subset the newly-named list to Melisandre.

``` r
(alias_list <- got_alias$aliases)
```

    ## [[1]]
    ## [1] "Prince of Fools" "Theon Turncloak" "Reek"            "Theon Kinslayer"
    ## 
    ## [[2]]
    ##  [1] "The Imp"            "Halfman"            "The boyman"        
    ##  [4] "Giant of Lannister" "Lord Tywin's Doom"  "Lord Tywin's Bane" 
    ##  [7] "Yollo"              "Hugor Hill"         "No-Nose"           
    ## [10] "Freak"              "Dwarf"             
    ## 
    ## [[3]]
    ## [1] "The Iron Captain"
    ## 
    ## [[4]]
    ## [1] ""
    ## 
    ## [[5]]
    ## [1] ""
    ## 
    ## [[6]]
    ## [1] ""
    ## 
    ## [[7]]
    ## [1] ""
    ## 
    ## [[8]]
    ## [1] ""
    ## 
    ## [[9]]
    ##  [1] "Dany"                    "Daenerys Stormborn"     
    ##  [3] "The Unburnt"             "Mother of Dragons"      
    ##  [5] "Mother"                  "Mhysa"                  
    ##  [7] "The Silver Queen"        "Silver Lady"            
    ##  [9] "Dragonmother"            "The Dragon Queen"       
    ## [11] "The Mad King's daughter"
    ## 
    ## [[10]]
    ## [1] "Onion Knight"    "Davos Shorthand" "Ser Onions"      "Onion Lord"     
    ## [5] "Smuggler"       
    ## 
    ## [[11]]
    ##  [1] "Arya Horseface"       "Arya Underfoot"       "Arry"                
    ##  [4] "Lumpyface"            "Lumpyhead"            "Stickboy"            
    ##  [7] "Weasel"               "Nymeria"              "Squan"               
    ## [10] "Saltb"                "Cat of the Canaly"    "Bets"                
    ## [13] "The Blind Girh"       "The Ugly Little Girl" "Mercedenl"           
    ## [16] "Mercye"              
    ## 
    ## [[12]]
    ## [1] ""
    ## 
    ## [[13]]
    ## [1] "Esgred"                "The Kraken's Daughter"
    ## 
    ## [[14]]
    ## [1] "Barristan the Bold" "Arstan Whitebeard"  "Ser Grandfather"   
    ## [4] "Barristan the Old"  "Old Ser"           
    ## 
    ## [[15]]
    ## [1] "Varamyr Sixskins" "Haggon"           "Lump"            
    ## 
    ## [[16]]
    ## [1] "Bran"            "Bran the Broken" "The Winged Wolf"
    ## 
    ## [[17]]
    ## [1] "The Maid of Tarth"  "Brienne the Beauty" "Brienne the Blue"  
    ## 
    ## [[18]]
    ## [1] "Catelyn Tully"     "Lady Stoneheart"   "The Silent Sistet"
    ## [4] "Mother Mercilesr"  "The Hangwomans"   
    ## 
    ## [[19]]
    ## NULL
    ## 
    ## [[20]]
    ## [1] "Ned"            "The Ned"        "The Quiet Wolf"
    ## 
    ## [[21]]
    ## [1] "The Kingslayer"        "The Lion of Lannister" "The Young Lion"       
    ## [4] "Cripple"              
    ## 
    ## [[22]]
    ## [1] "Griffthe Mad King's Hand"
    ## 
    ## [[23]]
    ## [1] "Lord Snow"                                    
    ## [2] "Ned Stark's Bastard"                          
    ## [3] "The Snow of Winterfell"                       
    ## [4] "The Crow-Come-Over"                           
    ## [5] "The 998th Lord Commander of the Night's Watch"
    ## [6] "The Bastard of Winterfell"                    
    ## [7] "The Black Bastard of the Wall"                
    ## [8] "Lord Crow"                                    
    ## 
    ## [[24]]
    ## [1] "The Damphair"   "Aeron Damphair"
    ## 
    ## [[25]]
    ## [1] ""
    ## 
    ## [[26]]
    ## [1] "The Red Priestess"     "The Red Woman"         "The King's Red Shadow"
    ## [4] "Lady Red"              "Lot Seven"            
    ## 
    ## [[27]]
    ## [1] "Merrett Muttonhead"
    ## 
    ## [[28]]
    ## [1] "Frog"                         "Prince Frog"                 
    ## [3] "The prince who came too late" "The Dragonrider"             
    ## 
    ## [[29]]
    ## [1] "Sam"              "Ser Piggy"        "Prince Pork-chop"
    ## [4] "Lady Piggy"       "Sam the Slayer"   "Black Sam"       
    ## [7] "Lord of Ham"     
    ## 
    ## [[30]]
    ## [1] "Little bird"  "Alayne Stone" "Jonquil"

``` r
names(alias_list) <- got_alias$name
alias_list[["Melisandre"]]
```

    ## [1] "The Red Priestess"     "The Red Woman"         "The King's Red Shadow"
    ## [4] "Lady Red"              "Lot Seven"

Approach 2: With piping

1.  Pipe `got_alias` into the `setNames()` function, to make a list of aliases, named after the person. Do you need `{` here?
2.  Then, pipe that into a subsetting function to subset Melisandre.

``` r
got_alias %>% 
  {setNames(.$aliases, .$name)} %>%
  `[[`("Melisandre")
```

    ## [1] "The Red Priestess"     "The Red Woman"         "The King's Red Shadow"
    ## [4] "Lady Red"              "Lot Seven"

Nesting/Unnesting; Operating
----------------------------

**Question**: What would tidy data of `got_alias` look like? Remember what `got_alias` holds:

``` r
got_alias
```

    ## # A tibble: 30 x 2
    ##    name               aliases   
    ##    <chr>              <list>    
    ##  1 Theon Greyjoy      <chr [4]> 
    ##  2 Tyrion Lannister   <chr [11]>
    ##  3 Victarion Greyjoy  <chr [1]> 
    ##  4 Will               <chr [1]> 
    ##  5 Areo Hotah         <chr [1]> 
    ##  6 Chett              <chr [1]> 
    ##  7 Cressen            <chr [1]> 
    ##  8 Arianne Martell    <chr [1]> 
    ##  9 Daenerys Targaryen <chr [11]>
    ## 10 Davos Seaworth     <chr [5]> 
    ## # ... with 20 more rows

Let's make a tidy data frame! First, let's take a closer look at `tidyr::unnest()` after making a tibble of preferred ice cream flavours:

``` r
(icecream <- tibble(
    name = c("Jacob", "Elena", "Mitchell"),
    flav = list(c("strawberry", "chocolate", "lemon"),
                c("straciatella", "strawberry"),
                c("garlic", "tiger tail"))
))
```

    ## # A tibble: 3 x 2
    ##   name     flav     
    ##   <chr>    <list>   
    ## 1 Jacob    <chr [3]>
    ## 2 Elena    <chr [2]>
    ## 3 Mitchell <chr [2]>

I can make a tidy data frame *without* list columns using `tidyr::unnest()`:

``` r
icecream %>% 
    unnest(flav)
```

    ## # A tibble: 7 x 2
    ##   name     flav        
    ##   <chr>    <chr>       
    ## 1 Jacob    strawberry  
    ## 2 Jacob    chocolate   
    ## 3 Jacob    lemon       
    ## 4 Elena    straciatella
    ## 5 Elena    strawberry  
    ## 6 Mitchell garlic      
    ## 7 Mitchell tiger tail

How would I subset all people that like strawberry ice cream? We can either use the tidy data, or the list data directly:

From "normal" tidy data:

``` r
icecream %>% 
    unnest(flav) %>% 
    filter(flav == "strawberry")
```

    ## # A tibble: 2 x 2
    ##   name  flav      
    ##   <chr> <chr>     
    ## 1 Jacob strawberry
    ## 2 Elena strawberry

From list-column data:

``` r
icecream %>% 
  filter(map_lgl(flav, ~ any(.x == "strawberry")))
```

    ## # A tibble: 2 x 2
    ##   name  flav     
    ##   <chr> <list>   
    ## 1 Jacob <chr [3]>
    ## 2 Elena <chr [2]>

Nesting/Unnesting: Your Turn
----------------------------

`unnest()` the `got_alias` tibble. Hint: there should be a hiccup. Check out the `str()`ucture of `got_alias` -- are all elements of the list column vectors? Would using `tidyr::drop_na()` be a good idea here?

``` r
str(got_alias)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    30 obs. of  2 variables:
    ##  $ name   : chr  "Theon Greyjoy" "Tyrion Lannister" "Victarion Greyjoy" "Will" ...
    ##  $ aliases:List of 30
    ##   ..$ : chr  "Prince of Fools" "Theon Turncloak" "Reek" "Theon Kinslayer"
    ##   ..$ : chr  "The Imp" "Halfman" "The boyman" "Giant of Lannister" ...
    ##   ..$ : chr "The Iron Captain"
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr  "Dany" "Daenerys Stormborn" "The Unburnt" "Mother of Dragons" ...
    ##   ..$ : chr  "Onion Knight" "Davos Shorthand" "Ser Onions" "Onion Lord" ...
    ##   ..$ : chr  "Arya Horseface" "Arya Underfoot" "Arry" "Lumpyface" ...
    ##   ..$ : chr ""
    ##   ..$ : chr  "Esgred" "The Kraken's Daughter"
    ##   ..$ : chr  "Barristan the Bold" "Arstan Whitebeard" "Ser Grandfather" "Barristan the Old" ...
    ##   ..$ : chr  "Varamyr Sixskins" "Haggon" "Lump"
    ##   ..$ : chr  "Bran" "Bran the Broken" "The Winged Wolf"
    ##   ..$ : chr  "The Maid of Tarth" "Brienne the Beauty" "Brienne the Blue"
    ##   ..$ : chr  "Catelyn Tully" "Lady Stoneheart" "The Silent Sistet" "Mother Mercilesr" ...
    ##   ..$ : NULL
    ##   ..$ : chr  "Ned" "The Ned" "The Quiet Wolf"
    ##   ..$ : chr  "The Kingslayer" "The Lion of Lannister" "The Young Lion" "Cripple"
    ##   ..$ : chr "Griffthe Mad King's Hand"
    ##   ..$ : chr  "Lord Snow" "Ned Stark's Bastard" "The Snow of Winterfell" "The Crow-Come-Over" ...
    ##   ..$ : chr  "The Damphair" "Aeron Damphair"
    ##   ..$ : chr ""
    ##   ..$ : chr  "The Red Priestess" "The Red Woman" "The King's Red Shadow" "Lady Red" ...
    ##   ..$ : chr "Merrett Muttonhead"
    ##   ..$ : chr  "Frog" "Prince Frog" "The prince who came too late" "The Dragonrider"
    ##   ..$ : chr  "Sam" "Ser Piggy" "Prince Pork-chop" "Lady Piggy" ...
    ##   ..$ : chr  "Little bird" "Alayne Stone" "Jonquil"

``` r
got_alias %>%
  drop_na() %>%
  unnest()
```

    ## # A tibble: 114 x 2
    ##    name             aliases           
    ##    <chr>            <chr>             
    ##  1 Theon Greyjoy    Prince of Fools   
    ##  2 Theon Greyjoy    Theon Turncloak   
    ##  3 Theon Greyjoy    Reek              
    ##  4 Theon Greyjoy    Theon Kinslayer   
    ##  5 Tyrion Lannister The Imp           
    ##  6 Tyrion Lannister Halfman           
    ##  7 Tyrion Lannister The boyman        
    ##  8 Tyrion Lannister Giant of Lannister
    ##  9 Tyrion Lannister Lord Tywin's Doom 
    ## 10 Tyrion Lannister Lord Tywin's Bane 
    ## # ... with 104 more rows

We can also do the opposite with `tidyr::nest()`. Try it with the `iris` data frame:

1.  Group by species.
2.  `nest()`!

``` r
iris
```

    ##     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
    ## 1            5.1         3.5          1.4         0.2     setosa
    ## 2            4.9         3.0          1.4         0.2     setosa
    ## 3            4.7         3.2          1.3         0.2     setosa
    ## 4            4.6         3.1          1.5         0.2     setosa
    ## 5            5.0         3.6          1.4         0.2     setosa
    ## 6            5.4         3.9          1.7         0.4     setosa
    ## 7            4.6         3.4          1.4         0.3     setosa
    ## 8            5.0         3.4          1.5         0.2     setosa
    ## 9            4.4         2.9          1.4         0.2     setosa
    ## 10           4.9         3.1          1.5         0.1     setosa
    ## 11           5.4         3.7          1.5         0.2     setosa
    ## 12           4.8         3.4          1.6         0.2     setosa
    ## 13           4.8         3.0          1.4         0.1     setosa
    ## 14           4.3         3.0          1.1         0.1     setosa
    ## 15           5.8         4.0          1.2         0.2     setosa
    ## 16           5.7         4.4          1.5         0.4     setosa
    ## 17           5.4         3.9          1.3         0.4     setosa
    ## 18           5.1         3.5          1.4         0.3     setosa
    ## 19           5.7         3.8          1.7         0.3     setosa
    ## 20           5.1         3.8          1.5         0.3     setosa
    ## 21           5.4         3.4          1.7         0.2     setosa
    ## 22           5.1         3.7          1.5         0.4     setosa
    ## 23           4.6         3.6          1.0         0.2     setosa
    ## 24           5.1         3.3          1.7         0.5     setosa
    ## 25           4.8         3.4          1.9         0.2     setosa
    ## 26           5.0         3.0          1.6         0.2     setosa
    ## 27           5.0         3.4          1.6         0.4     setosa
    ## 28           5.2         3.5          1.5         0.2     setosa
    ## 29           5.2         3.4          1.4         0.2     setosa
    ## 30           4.7         3.2          1.6         0.2     setosa
    ## 31           4.8         3.1          1.6         0.2     setosa
    ## 32           5.4         3.4          1.5         0.4     setosa
    ## 33           5.2         4.1          1.5         0.1     setosa
    ## 34           5.5         4.2          1.4         0.2     setosa
    ## 35           4.9         3.1          1.5         0.2     setosa
    ## 36           5.0         3.2          1.2         0.2     setosa
    ## 37           5.5         3.5          1.3         0.2     setosa
    ## 38           4.9         3.6          1.4         0.1     setosa
    ## 39           4.4         3.0          1.3         0.2     setosa
    ## 40           5.1         3.4          1.5         0.2     setosa
    ## 41           5.0         3.5          1.3         0.3     setosa
    ## 42           4.5         2.3          1.3         0.3     setosa
    ## 43           4.4         3.2          1.3         0.2     setosa
    ## 44           5.0         3.5          1.6         0.6     setosa
    ## 45           5.1         3.8          1.9         0.4     setosa
    ## 46           4.8         3.0          1.4         0.3     setosa
    ## 47           5.1         3.8          1.6         0.2     setosa
    ## 48           4.6         3.2          1.4         0.2     setosa
    ## 49           5.3         3.7          1.5         0.2     setosa
    ## 50           5.0         3.3          1.4         0.2     setosa
    ## 51           7.0         3.2          4.7         1.4 versicolor
    ## 52           6.4         3.2          4.5         1.5 versicolor
    ## 53           6.9         3.1          4.9         1.5 versicolor
    ## 54           5.5         2.3          4.0         1.3 versicolor
    ## 55           6.5         2.8          4.6         1.5 versicolor
    ## 56           5.7         2.8          4.5         1.3 versicolor
    ## 57           6.3         3.3          4.7         1.6 versicolor
    ## 58           4.9         2.4          3.3         1.0 versicolor
    ## 59           6.6         2.9          4.6         1.3 versicolor
    ## 60           5.2         2.7          3.9         1.4 versicolor
    ## 61           5.0         2.0          3.5         1.0 versicolor
    ## 62           5.9         3.0          4.2         1.5 versicolor
    ## 63           6.0         2.2          4.0         1.0 versicolor
    ## 64           6.1         2.9          4.7         1.4 versicolor
    ## 65           5.6         2.9          3.6         1.3 versicolor
    ## 66           6.7         3.1          4.4         1.4 versicolor
    ## 67           5.6         3.0          4.5         1.5 versicolor
    ## 68           5.8         2.7          4.1         1.0 versicolor
    ## 69           6.2         2.2          4.5         1.5 versicolor
    ## 70           5.6         2.5          3.9         1.1 versicolor
    ## 71           5.9         3.2          4.8         1.8 versicolor
    ## 72           6.1         2.8          4.0         1.3 versicolor
    ## 73           6.3         2.5          4.9         1.5 versicolor
    ## 74           6.1         2.8          4.7         1.2 versicolor
    ## 75           6.4         2.9          4.3         1.3 versicolor
    ## 76           6.6         3.0          4.4         1.4 versicolor
    ## 77           6.8         2.8          4.8         1.4 versicolor
    ## 78           6.7         3.0          5.0         1.7 versicolor
    ## 79           6.0         2.9          4.5         1.5 versicolor
    ## 80           5.7         2.6          3.5         1.0 versicolor
    ## 81           5.5         2.4          3.8         1.1 versicolor
    ## 82           5.5         2.4          3.7         1.0 versicolor
    ## 83           5.8         2.7          3.9         1.2 versicolor
    ## 84           6.0         2.7          5.1         1.6 versicolor
    ## 85           5.4         3.0          4.5         1.5 versicolor
    ## 86           6.0         3.4          4.5         1.6 versicolor
    ## 87           6.7         3.1          4.7         1.5 versicolor
    ## 88           6.3         2.3          4.4         1.3 versicolor
    ## 89           5.6         3.0          4.1         1.3 versicolor
    ## 90           5.5         2.5          4.0         1.3 versicolor
    ## 91           5.5         2.6          4.4         1.2 versicolor
    ## 92           6.1         3.0          4.6         1.4 versicolor
    ## 93           5.8         2.6          4.0         1.2 versicolor
    ## 94           5.0         2.3          3.3         1.0 versicolor
    ## 95           5.6         2.7          4.2         1.3 versicolor
    ## 96           5.7         3.0          4.2         1.2 versicolor
    ## 97           5.7         2.9          4.2         1.3 versicolor
    ## 98           6.2         2.9          4.3         1.3 versicolor
    ## 99           5.1         2.5          3.0         1.1 versicolor
    ## 100          5.7         2.8          4.1         1.3 versicolor
    ## 101          6.3         3.3          6.0         2.5  virginica
    ## 102          5.8         2.7          5.1         1.9  virginica
    ## 103          7.1         3.0          5.9         2.1  virginica
    ## 104          6.3         2.9          5.6         1.8  virginica
    ## 105          6.5         3.0          5.8         2.2  virginica
    ## 106          7.6         3.0          6.6         2.1  virginica
    ## 107          4.9         2.5          4.5         1.7  virginica
    ## 108          7.3         2.9          6.3         1.8  virginica
    ## 109          6.7         2.5          5.8         1.8  virginica
    ## 110          7.2         3.6          6.1         2.5  virginica
    ## 111          6.5         3.2          5.1         2.0  virginica
    ## 112          6.4         2.7          5.3         1.9  virginica
    ## 113          6.8         3.0          5.5         2.1  virginica
    ## 114          5.7         2.5          5.0         2.0  virginica
    ## 115          5.8         2.8          5.1         2.4  virginica
    ## 116          6.4         3.2          5.3         2.3  virginica
    ## 117          6.5         3.0          5.5         1.8  virginica
    ## 118          7.7         3.8          6.7         2.2  virginica
    ## 119          7.7         2.6          6.9         2.3  virginica
    ## 120          6.0         2.2          5.0         1.5  virginica
    ## 121          6.9         3.2          5.7         2.3  virginica
    ## 122          5.6         2.8          4.9         2.0  virginica
    ## 123          7.7         2.8          6.7         2.0  virginica
    ## 124          6.3         2.7          4.9         1.8  virginica
    ## 125          6.7         3.3          5.7         2.1  virginica
    ## 126          7.2         3.2          6.0         1.8  virginica
    ## 127          6.2         2.8          4.8         1.8  virginica
    ## 128          6.1         3.0          4.9         1.8  virginica
    ## 129          6.4         2.8          5.6         2.1  virginica
    ## 130          7.2         3.0          5.8         1.6  virginica
    ## 131          7.4         2.8          6.1         1.9  virginica
    ## 132          7.9         3.8          6.4         2.0  virginica
    ## 133          6.4         2.8          5.6         2.2  virginica
    ## 134          6.3         2.8          5.1         1.5  virginica
    ## 135          6.1         2.6          5.6         1.4  virginica
    ## 136          7.7         3.0          6.1         2.3  virginica
    ## 137          6.3         3.4          5.6         2.4  virginica
    ## 138          6.4         3.1          5.5         1.8  virginica
    ## 139          6.0         3.0          4.8         1.8  virginica
    ## 140          6.9         3.1          5.4         2.1  virginica
    ## 141          6.7         3.1          5.6         2.4  virginica
    ## 142          6.9         3.1          5.1         2.3  virginica
    ## 143          5.8         2.7          5.1         1.9  virginica
    ## 144          6.8         3.2          5.9         2.3  virginica
    ## 145          6.7         3.3          5.7         2.5  virginica
    ## 146          6.7         3.0          5.2         2.3  virginica
    ## 147          6.3         2.5          5.0         1.9  virginica
    ## 148          6.5         3.0          5.2         2.0  virginica
    ## 149          6.2         3.4          5.4         2.3  virginica
    ## 150          5.9         3.0          5.1         1.8  virginica

``` r
iris %>%
  group_by(Species) %>%
  nest()
```

    ## # A tibble: 3 x 2
    ##   Species    data             
    ##   <fct>      <list>           
    ## 1 setosa     <tibble [50 × 4]>
    ## 2 versicolor <tibble [50 × 4]>
    ## 3 virginica  <tibble [50 × 4]>

Keep the nested `iris` data frame above going! Keep piping:

-   Fit a linear regression model with `lm()` to `Sepal.Length ~ Sepal.Width`, separately for each species.
    -   Inspect, to see what's going on.
-   Get the slope and intercept information by applying `broom::tidy()` to the output of `lm()`.
-   `unnest` the outputted data frames from `broom::tidy()`.

Application: Time remaining?
============================

If time remains, here is a good exercise to put everything together.

[Hilary Parker tweet](https://twitter.com/hspter/status/739886244692295680): "How do you sample from groups, with a different sample size for each group?"

[Solution by Jenny Bryan](https://jennybc.github.io/purrr-tutorial/ls12_different-sized-samples.html):

1.  Nest by species.
2.  Specify sample size for each group.
3.  Do the subsampling of each group.

Let's give it a try:

Summary:
========

-   tibbles can hold columns that are lists, too!
    -   Useful for holding variable-length data.
    -   Useful for holding unusual data (example: a probability density function)
    -   Whereas `dplyr` maps vectors of length `n` to `n`, or `n` to `1`...
    -   ...list columns allow us to map `n` to any general length `m` (example: regression on groups)
-   `purrr` is a useful tool for operating on list-columns.
-   `purrr` allows for parallel mapping of iterables (vectors/lists) with the `map2` and `pmap` families.
