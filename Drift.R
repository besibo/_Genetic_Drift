# drift() simulates the effect of genetic drift on allele frequencies in a
# finite population. It provides a three-column tibble:
# 1. Generation number
# 2. Allele name
# 3. Allele frequency
#
# Arguments:
# pop_size: population size
# allele_freq: initial frequencies of alleles. The sum must be 1
# generations <- 100: number of generations

drift <- function(pop_size = 100, allele_freq = c(0.5, 0.5), generations = 100) {
    require(tidyverse)

    # Create the list of alleles at generation 0
    allele_nb <- length(allele_freq)
    allele_list <- factor(rep(letters[1:allele_nb], round(pop_size * allele_freq)))

    # Create a data.frame in which we'll store the resuts
    res <- matrix(ncol = allele_nb, nrow = generations)
    res <- as.tibble(res)
    names(res) <- letters[1:allele_nb]
    res[1, ] <- allele_freq

    # Compute allele frequencies for all generations
    for (i in 2:generations) {
        allele_list <- factor(
            sample(allele_list, length(allele_list), replace = TRUE),
            levels = letters[1:allele_nb])
        res[i, ] <- table(allele_list) / length(allele_list)
    }

    # Add the generation number and re-organize the tibble in the "long" format
    out <- res %>%
        mutate(Generation = 1:nrow(res)) %>%
        gather(Allele, Frequency, letters[1:allele_nb])

    return(out)
}

ggdrift <- function(drift_table, pop_size) {
    require(ggplot2)
    require(viridisLite)

    # Define colorblind-friendly palette for up to 8 alleles
    allele_number <- length(unique(drift_table$Allele))

    if (allele_number < 9) {
        cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
                       "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
    } else {
        cbPalette <- viridis(allele_number)
    }

    # Plot
    ggp <- ggplot(data = drift_table,
                  aes(x = Generation, y = Frequency, colour = Allele)) +
        geom_line(size = .5) + ylim(0, 1) + ylab("Allele frequency") +
        scale_colour_manual(values = cbPalette) +
        ggtitle(paste("Population size: ", pop_size, sep = ""))

    ggp
}

# Generates a vector of length n that adds up to one
# n: the number of values to generate
# digits: number of significant digits
# different: should the numbers be the same (FALSE) or not (TRUE)
sum_to_one <- function(n, digits=3, different=TRUE) {
    if (different) {
        vlo <- runif(n, 0, 1)
        vlo <- round(vlo/sum(vlo), digits)
    } else {
        vlo <- round(rep(1/n, n), digits)
    }
    out <- c(vlo[1:(n-1)], 1-sum(vlo[1:(n-1)]))
    return(out)
}
