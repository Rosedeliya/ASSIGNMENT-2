#======================IMPORTING REQUIRED PACKAGES==========================#
import Pkg
using Pkg
Pkg.add("IterTools")
using IterTools

#===================DEFINING THE KNAPSACK PARAMETERS========================#

#===================Describing the objects==================================#
#Number of objects
println("Enter number of objects: ")
n = parse(Int, readline())

#Capacity of the KNAPSACK
println("Enter Maximum Weight Capacity: ")
capacity = parse(Float64, readline())

#Initializing the aray of all object weights
weights = zeros(n)

#Initializing the aray of oll corresponding object values
objectValues = zeros(n)


#Specifying object properties (weights and values)
for i = 1:n
    println("Enter item ", i, "'s weight")
    weights[i] = parse(Float64, readline())

    println("Enter item ", i, "'s value")
    objectValues[i] = parse(Float64, readline())
end

#A set of all the subsets of the objects powerset
weightSubsets = collect(subsets(weights))
valueSubsets = collect(subsets(objectValues))

#======================HILL CLIMBING SOLUTiON============================#

#Weight combinations of initial solution (no objects in the KNAPSACK)
weightSolution = zeros(n)

#Values combinations of initial solution (no objects in the KNAPSACK)
valueSolution = zeros(n)

#Finding the actual Solution
function Solution()

    valueSolution = zeros(n)    #Initial empty solution set
    solutionSum = sum(valueSolution) #Sum of the Values of solution set
    weightSum = sum(weightSolution) # Sum of the weights of the solution set
    println("Initially, the Knapsack is empty, so we start looking for the best solution")
    for i = 1:2^n
    #Defining the new solution set (KNAPSACK contents)
    weightSolution = weightSubsets[i]
    valueSolution = valueSubsets[i]

        #Check all subsets of the initial objects set for the best combination of objects
        if sum(weightSolution) <= capacity && sum(valueSolution) > solutionSum
                solutionSum = sum(valueSolution)
                weightSum = sum(weightSolution)
                global finalValueSet = valueSolution
                global finalWeightSet = weightSolution
                #Displaying the current best solutions
                print("The current best value for scores total is: ", solutionSum)
                println("  With a total weight of: ", weightSum)
                println("Summed from the following Values: ", valueSolution)
                println(" Whose respective weights are: ", weightSolution)

        end
    end
    #Printing the final solution
    println("\n")
    println("##################################################################")
    println("The highest score is: ", solutionSum)
    println("With a total weight of: ", weightSum)
    println("Summed from items with the following Values: ", finalValueSet)
    println("And whose respective weights are: ", finalWeightSet)
    println("##################################################################")
end

#Calling the Solution function to display the final result

Solution()
