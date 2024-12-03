% Author: Bikash Kunwar / bzk0067@auburn.edu
% Date: 2024-09-01
% Assignment Name: hw06


classdef hw06
    methods (Static)

        % Problem 1

        function ret = p1(func, a, b, n, option)
            % Implement composite quadrature rules for numerical integration
            % of a function over the interval [a, b] with n subintervals.
            % The option parameter determines the type of quadrature rule to use:
            % 1 for the midpoint rule, 2 for the trapezoidal rule, and 3 for Simpson's rule.

            %:param func: The function to integrate, provided as a function handle.
            %:param a: The lower bound of the integration interval.
            %:param b: The upper bound of the integration interval.
            %:param n: The number of subintervals to use for the integration.
            %:param option: The type of quadrature rule to use (1, 2, or 3).
            %:return: The approximate integral of the function over the interval [a, b].

            % your code here.
            if option == 1
                % your code of composite midpoint rule
                h = (b-a)/n;
                x(1) = a;
                dI = 0;
                for i = 1:n
                    x(i+1) = x(i) +h;
                    q = (x(i)+x(i+1))/2;
                    dI = dI + h*func(q);
                end
                ret = dI;
            elseif option == 2
                % your code of composite trapezoidal rule
                h = (b-a)/n;
                x(1) = a;
                dI = 0;
                for i = 1:n
                    x(i+1) = x(i) +h;
                    dI = dI + h/2* (func(x(i)) + func(x(i+1)));
                end
                ret = dI;
            elseif option == 3
                % your code of composite Simpson's rule
                if mod(n, 2) ~= 0
                    error('n must be even for Simpsons rule');
                end
                h = (b-a)/n;
                x(1) = a;
                dI = 0;
                for i = 1:2:n
                    x(i+1) = x(i) + h;
                    x(i+2) = x(i) + 2*h;
                    dI = dI + 2*h/6* (func(x(i)) + 4*func(x(i+1)) + func(x(i+2)));
                end
                ret = dI;
            else
                error('Invalid option: %d', option);
            end
        end


        % Problem 2

        function p2()
            % run with the following command: hw06.p2(). Do not edit this function.
            %
            % It checks the convergence of the composite quadrature rules implemented in p1.
            %
            % Here we use some examples,
            % f_1(x) = exp(x)
            % f_2(x) = (1 - x^2)^3, this function's first 2 derivatives at the endpoints are zero.
            % f_3(x) = (1 - x^2)^5, this function's first 4 derivatives at the endpoints are zero.
            % f_4(x) = (1 - x^2)^7, this function's first 6 derivatives at the endpoints are zero.

            % Run this function will plot the figures for the convergence of the composite quadrature rules.
            % Make comments about the results obtained from the plots.
            %
            % > For instance, you can comment on the convergence rates of the quadrature rules, and how they compare to the theoretical rates.
            % > Here are a few example questions you can answer in your comments:
            % > Does the Runge phenomenon of f1 (Runge's function) lower the convergence rate?
            % > Does Simpson's rule have a faster convergence rate than the other two for these examples?
            % > Based on your observations, what kind of functions can have a faster convergence rate with the given composite quadrature rules?

            % Write your comments here.
            % f_1(x) = exp(x) has the slowest convergence (second order) for the midpoint
            % and the trapezoidal rule as the number of sub-itervals are increased. For the Simpson's rule, the
            % convergence rate is slightly higher than the fourth order.The Ruge phenomenon of f1 lowers the convergence for f_1.

            % The convergence of all three quadrature rules is almost
            % fourth order for f_2(x) = (1 - x^2)^3 with Simpson's rule
            % having a little higher absoute error for a given number of
            % intervals than the midpoint and trapezoidal.

            % The convergence for all quadrature rule increases for f_3 and
            % f_4 compared to f_1 and f_2. For f_3 and f_4, the midpoint and trapezoidal
            % rule have the same covnergence rate (little less than  6th order
            % convergence for f_3 and little more for f_4), and the
            % Simpson's rule trails behind (meaning the absolute error is more for Simpson's rule at given number of subintervals).
            % For f_3 and f_4, all three rules cross the 4th order convergence rate as the
            % number of intervals is increased.For f_4, the three rules
            % also cross the 6th order convergene rule. The midpoint and
            % the trapezoid rule do so at one order  of intervals less
            % compared to simpson's.

            % In conclusion, the f_4 has the maximum convergence rates for
            % all quadrature rules. It appears, higher
            % number of derivatives at the endpoints for a function, higher
            % the convergence rate.


            f = {  @(x)exp(x),  @(x) (1 - x.^2 ).^3, @(x)(1 - x.^2).^5,  @(x) (1 - x.^2).^7} ;  % Define the integrand
            exact = [exp(1) - exp(-1), 32/35, 512/693 , 4096/6435];  % Define the exact integral
            n = 2.^(1:8);  % Define the number of subintervals
            for k = 1 : length(f)

                error = zeros(3, length(n));  % Initialize the error matrix with zeros

                % Calculate the approximate integral and the error for each quadrature rule and number of subintervals
                for i = 1 : length(n)
                    error(1, i) = abs(hw06.p1(f{k},-1, 1, n(i), 1) - exact(k));
                    error(2, i) = abs(hw06.p1(f{k},-1, 1, n(i), 2) - exact(k));
                    error(3, i) = abs(hw06.p1(f{k},-1, 1, n(i), 3) - exact(k));
                end

                % Plot the error against the number of subintervals using a log-log scale
                figure(k);

                loglog(n, error(1, :), 'r-+', 'LineWidth', 2);
                hold on;
                loglog(n, error(2, :), 'g-d', 'LineWidth', 2);
                loglog(n, error(3, :), 'b-x', 'LineWidth', 2);

                loglog(n, 1./ n.^2, 'm--', 'LineWidth', 1);
                loglog(n, 1./ n.^4, 'k-.', 'LineWidth', 1);
                loglog(n, 1./ n.^6, 'm--d', 'LineWidth', 1);
                loglog(n, 1./ n.^8, 'k--o', 'LineWidth', 1);

                xlabel('Number of subintervals');
                ylabel('Absolute error');
                title(sprintf('Convergence of composite quadrature rules for %s', functions(f{k}).function));
                legend('Midpoint rule', 'Trapezoidal rule', 'Simpson''s rule', '2nd order convergence', '4th order convergence', '6th order convergence', '8th order convergence', 'Location', 'best');
                grid on;
                hold off;
            end

        end


        % Problem 3

        function ret = p3(func, a, b, N, option)
            % Use your implemented Richardson extrapolation function in HW05 to implement the Romberg integration method.
            %
            % :param func: The function to integrate, provided as a function handle.
            % :param a: The lower bound of the integration interval.
            % :param b: The upper bound of the integration interval.
            % :param N: it means 2^N is the maximum number of subintervals to use for the integration.
            %           The Romberg method will start with 2^1=2 subintervals and double the number of subintervals until 2^N
            % :param option: The type of quadrature rule to use (1, 2, or 3). See p1.
            % :return: The approximate integral of the function over the interval [a, b].

            % Note, the "powers" used in Richardson extrapolation (see hw05.m) should be [2, 4, 6, ...] for option 1 and 2.
            % For option 3, the "powers" should be [4, 6, 8, ...].

            % your code here.
            % Initialize variables
            h = b - a; % Initial step size
            T = zeros(N + 1, N + 1); % Romberg table

            % Adjust initial number of subintervals for Simpson's rule
            if option == 3
                initial_subintervals = 2; % Start with 2 subintervals for Simpson's rule
            else
                initial_subintervals = 1; % Start with 1 subinterval for midpoint/trapezoidal
            end

            % Compute T(1,1) using the initial quadrature rule
            T(1, 1) = hw06.p1(func, a, b, initial_subintervals, option);

            % Fill the Romberg table
            for k = 2:N+1
                % Number of subintervals
                n = 2^(k-1);

                % Compute T(k,1) using the composite quadrature rule
                T(k, 1) = hw06.p1(func, a, b, n, option);

                % Richardson extrapolation
                for j = 2:k
                    % Powers depend on the rule: 2 for midpoint and trapezoidal, 4 for Simpson's
                    p = 2; % Default power for midpoint/trapezoidal
                    if option == 3
                        p = 4; % Power for Simpson's rule
                    end
                    T(k, j) = (4^(j-1) * T(k, j-1) - T(k-1, j-1)) / (4^(j-1) - 1);
                end
            end

            % Return the most accurate estimate
            ret = T(N+1, N+1);

        end





        % Problem 4

        function ret = p4()
            % Construct the Gauss quadrature rule using the roots of the Legendre polynomial of degree 6.
            %
            % % To evaluate Legendre polynomial of degree 6, use the helper function hw06.legendre_poly_6 defined below.
            % % Its handle is @hw06.legendre_poly_6.
            % %
            % % :return: A 6x2 matrix containing the roots and weights of the Gauss quadrature rule.
            % %          The first column contains the roots and the second column contains the corresponding weights.
            % roots = zeros(6, 1);
            % weights = zeros(6, 1);
            %
            % % your code here.
            %
            % ret = [roots, weights];  % Return the roots and weights of the Gauss quadrature rule



            % Define the Legendre polynomial P6(x) and its derivative
            P6 = @(x) hw06.legendre_poly_6(x);
            P6_derivative = @(x) (1/16) * (1386*x.^5 - 1260*x.^3 + 210*x); % Derivative of P6(x), common method for p4 and p5

            % Define the intervals where roots are known to exist
            intervals = [-1, -3/4; -3/4, -1/4; -1/4, 0; 0, 1/4; 1/4, 3/4; 3/4, 1];

            % Find roots using bisection method
            roots = zeros(6, 1); % Preallocate array for roots
            tolerance = 1e-14;   % Stopping criterion

            for i = 1:size(intervals, 1)
                a = intervals(i, 1);
                b = intervals(i, 2);
                while abs(b - a) > tolerance
                    c = (a + b) / 2; % Midpoint
                    if P6(a) * P6(c) < 0
                        b = c; % Root is in [a, c]
                    else
                        a = c; % Root is in [c, b]
                    end
                end
                roots(i) = (a + b) / 2; % Final midpoint as root
            end

            % Compute the weights for each root
            weights = zeros(6, 1); % Preallocate array for weights
            for i = 1:6
                % Weight formula: w_i = 2 / ((1 - xi^2) * [P6'(xi)]^2)
                xi = roots(i);
                weights(i) = 2 / ((1 - xi^2) * (P6_derivative(xi))^2);
            end

            % Combine roots and weights into a single matrix
            ret = [roots, weights];
        end


        function ret = p5(n)
            % For 6630 ONLY.

            % Construct the Gauss quadrature rule using the roots of the Legendre polynomial of degree n
            %
            % :param n: The degree of the Legendre polynomial for the nodes of the Gauss quadrature rule.
            % :return: An nx2 matrix containing the roots and weights of the Gauss quadrature rule.
            %
            % To evaluate Legendre polynomial or its derivative of a specific degree n, the handles are:
            % @(x) hw06.legendre_poly(n, x) and @(x) hw06.deriv_lengendre_poly(n, x).
            %

            roots = zeros(n, 1);
            weights = zeros(n, 1);

            % your code here.

            % ret = [roots, weights];  % Return the roots and weights of the Gauss quadrature rule

            Pn = @(x) hw06.legendre_poly(n, x);
            Pn_derivative = @(x) hw06.deriv_legendre_poly(n, x);

            % Initialize arrays for roots and weights
            roots = zeros(n, 1);
            weights = zeros(n, 1);

            % Define tolerance for convergence
            tolerance = 1e-14;

            % Use numerical root-finding to find the roots
            % Roots of Legendre polynomials are symmetric, so we only need to solve for half of them
            for i = 1:ceil(n/2)
                % Initial guess for the root (Chebyshev nodes are a good starting point)
                x0 = cos(pi * (i - 0.25) / (n + 0.5));

                % Use Newton-Raphson to refine the root
                iter = 0;
                while iter < 100
                    fx = Pn(x0);
                    dfx = Pn_derivative(x0);
                    x1 = x0 - fx / dfx; % Newton-Raphson update
                    if abs(x1 - x0) < tolerance
                        break;
                    end
                    x0 = x1;
                    iter = iter + 1;
                end

                % Store the root and its symmetric counterpart
                roots(i) = x1;
                if i ~= n - i + 1
                    roots(n - i + 1) = -x1; % Symmetry
                end
            end

            % Sort roots (ensure correct ordering for weights calculation)
            roots = sort(roots);

            % Calculate the weights
            for i = 1:n
                xi = roots(i);
                weights(i) = 2 / ((1 - xi^2) * (Pn_derivative(xi))^2);
            end

            % Combine roots and weights into a single matrix
            ret = [roots, weights];

            % Display the roots and weights
            % disp('Roots and weights of Gauss quadrature rule:');
            % disp(ret);
        end



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                                                             %
        % Helper functions below. Do not modify. You can create your own helper functions if needed.                  %
        %                                                                                                             %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Helper functions for p4. The following function is used to evaluate the Legendre polynomial of degree 6.
        function val = legendre_poly_6(x)
            % Compute the Legendre polynomial of degree 6 at the point x.
            %
            % :param x: The point at which to evaluate the Legendre polynomial.
            % :return: The value of the Legendre polynomial of degree 6 at the point x.

            val = (231 * x^6 - 315 * x^4 + 105 * x^2 - 5) / 16;
        end

        % Helper functions for p5. The following function is used to evaluate the Legendre polynomial of degree n.
        function val = legendre_poly(n, x)
            % Compute the nth Legendre polynomial P_n at the point x.
            %
            % :param n: The degree of the Legendre polynomial.
            % :param x: The point at which to evaluate the Legendre polynomial.
            % :return: The value of the nth Legendre polynomial at the point x.

            if (n == 0)
                val = 1;
            elseif (n == 1)
                val = x;
            else
                val = hw06.legendre_poly(n-1, x) * x * (2 * n - 1)/n - (n - 1) * hw06.legendre_poly(n - 2, x) / n;
            end
        end

        function val = deriv_legendre_poly(n, x)
            % Compute the derivative of the nth Legendre polynomial P_n at the point x.
            %
            % :param n: The degree of the Legendre polynomial.
            % :param x: The point at which to evaluate the derivative of the Legendre polynomial.
            % :return: The value of the derivative of the nth Legendre polynomial at the point x.
            val = n / (x^2 - 1) * (x * hw06.legendre_poly(n, x) - hw06.legendre_poly(n - 1, x));
        end
    end
end

