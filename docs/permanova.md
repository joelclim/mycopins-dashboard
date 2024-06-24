PERMANOVA (Permutational Multivariate Analysis of Variance) is a non-parametric statistical test used to compare the differences in community composition among groups. It can help determine if there are significant differences in fungal community composition across different time points, environmental conditions, or treatment groups
#### Key Metrics
<b>R-squared (R²)</b>
The R-squared value, also known as the coefficient of determination, indicates the proportion of variation in the data that is explained by the grouping variable(s) in the model. R-squared values range from 0 to 1, where 0 means no variation can be explained by the model, while 1 means all variation is explained by the model.

* <u>Higher R-squared values indicate that a greater proportion of the variation in community composition is explained by the grouping variable(s).</u>
* <u>Lower R-squared values suggest that the grouping variable(s) explain little of the variation in community composition.</u>

<b>F-statistic</b>
 The F-statistic in PERMANOVA is a ratio of the variance explained by the grouping variable(s) to the variance within groups. It is calculated similarly to the F-statistic in traditional ANOVA.

* <u>Higher F-statistic values indicate that the between-group variance is much larger than the within-group variance, suggesting significant differences in community composition between groups.</u>
* <u>Lower F-statistic values suggest that the between-group variance is not much larger than the within-group variance, indicating little to no difference in community composition between groups.</u>

<b>P-value</b>
The p-value in PERMANOVA indicates the statistical significance of the observed differences in community composition between groups. It is obtained through permutations of the data. Commonly used thresholds for significance are p < 0.05 or p < 0.01.

* <u>Low p-value (< 0.05): Reject the null hypothesis of no difference in community composition between groups. This indicates that the observed differences are statistically significant.</u>
* <u>High p-value (≥ 0.05): Fail to reject the null hypothesis. This suggests that the observed differences are not statistically significant and could be due to random chance.</u>