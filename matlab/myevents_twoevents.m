% --------------------------------------------------------------
function [value,isterminal,direction] = myevents_twoevents(t,y)
% Locate the time when height passes through zero in a 
% decreasing direction and stop integration.
global deltau1

% value = (y(1)-deltau1);     % Detect height = 0
% isterminal = 1;   % Stop the integration
% direction = -1;   % Negative direction only

value = [y(1)-deltau1;
       y(2)];

isterminal = [1 ; 1];            % Stop at local minimum
direction = [1;  -1];            % [local minimum, local maximum]