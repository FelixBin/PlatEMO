classdef BSDE < ALGORITHM
    % <single> <real> <constrained/none>
    % Bernstain-search differential evolution algorithm

    %------------------------------- Reference --------------------------------
    % Civicioglu P ,  Besdok E . Bernstain-search differential evolution algorithm
    % for numerical function optimization[J].
    % Expert Systems with Applications, 2019, 138:112831.

    methods
        function main(Algorithm,Problem)

            % 初始化种群
            Population = Problem.Initialization();
            fitPopulation=FitnessSingle(Population);
            [~,best]   = min(fitPopulation);
            bestP      = Population(best);%当前种群最优一个的决策变量

            %% Optimization
            while Algorithm.NotTerminated(Population)

                %当前子代种群
                Offspring=  OperatorBSDE(Population,bestP,Problem);

                %当前子代种群适应度值
                fitOffspring=FitnessSingle(Offspring);

                %根据当前最优适应度值并更新原种群
                replace = fitOffspring < fitPopulation;
                fitPopulation(replace) = fitOffspring(replace);%适应度值更新
                Population(replace)=Offspring(replace);%种群更新
                [solP,replace] = min(fitPopulation);%获取当前最新最小适应度值
                bestP =Population(replace);

                out.globalminimum = solP;
                out.globalminimizer = bestP;
                assignin('base','outAlgo',out);
            end
        end
    end
end

