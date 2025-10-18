#2.2 
The slope of this relationship is 0.37757, which means that for additional year of the mother's age the number of de novo mutations are expected to increase by 0.37757. This does seem to match my plot and the p-value is under 0.05 so this relationship does seem to be significant. 

#2.3 
The slope of this relationship is 1.35384, which means that for additional year of the father's age the number of de novo mutations are expected to increase by 1.35384. This does seem to match my plot and the p-value is under 0.05 so this relationship does seem to be significant. 

#2.4 
paternal_model <- lm(data = counts_pat, formula = count ~ 1 + Father_age )
new_data <- data.frame(Father_age = 50.5)
predict(paternal_model, newdata = new_data)
--> 78.69546 

#2.6
This result indicates that fathers contribute about 39 more DNMs than mothers on average and this does seem to match my plot. 
The relationship seems to be highly significant because the p-value is less than 2.2 X 10^-16. This represents the fact that the probability that this difference in contribution to DNMs is by random chance is close to zero.
The intercept output from the lm() model is 39.23, which again represents the average difference in DNMs between fathers and mothers. This is the same result of the paired t-test and confirms that the average DNM contribution from fathers is significantly higher.

#3.1 
I chose to look at the accidents on April 20th dataset, from a preliminary look at the data it seems that on average there are less accidents on 04/20 than on other days (ex3_a.png) and the average number of fatalities per day per year seems to be decreasing overall (ex3_b.png). 

I tested if fatalities on April 20 are lower than on other days because I found that finding pretty strange. The average number of fatalities on days other than 04/20 was approximately 145 and the holiday seems to have 90 fewer fatalities on average. This difference also seems to be statistically significant (p < 2e-16). 

These results correspond well to the chart I generated earlier and this data seems to provide evidence that there might be fewer car accident related fatalities on the 20th of April compared to other days. 

