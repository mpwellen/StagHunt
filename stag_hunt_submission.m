function stag_hunt_v2
% FILE: stag_hunt.m runs the 2x2 Stag-Hunt game
%
% DESCRIPTION:
% Each agent randomly chooses an action from the set {S,H}. The utility of
% the joint action set is given by the Stag-Hunt game. This game has two
% nash equilibrium: (S,S) and (H,H).
%
% INPUTS:
% None
%
% OUTPUTS:
% Plots cumulative sum of each player's payoffs
% Plots histogram of state of game
%
% TODO:
% Implement and use the Best Reply Dynmaics with Inertia Learning Rule.
%%%%%%%%%%%%%

%K trials of experiment 
K = 100;

%Number of iterations per game
tf = 1000;

%Parameter used to mimic coin tosses
rho = 0.99;

%Time spent in each state (for all trials, over all iterations)
state_linger_info = [];

for trials=1:1:K
    %Store action and utility for each player, and the state of a game
    utility_history = zeros(2, tf);
    action_history = cell(2, tf);
    state_history = zeros(1, tf);
    
    %Play Stag-Hunt for tf iterations
    for t=1:1:tf
        %Players acting randomly
        if t==1
            actions = get_random_action;
        else
            state=get_state(actions);
            actions=get_BRwI_action(rho, state);
        end
        
        %Player employing the Best Reply with Inertia Learning Rule
        %actions = get_BRwI_action(rho, ..., ...); TO BE IMPLEMENTED!!!
        
        %Utility of each player is a 2x1 vector, where first row is the row
        %player's utility and second row is the col player's utility
        utility = get_utility(actions);
        state = get_state(actions);
        
        %Store the action, utility, and state for this particular game
        action_history(:, t) = {actions{1}; actions{2}};
        utility_history(:, t) = utility;
        state_history(:, t) = state;
    end
    
    %Print entire game history to the screen
    disp(action_history(:, 1:1:end))
    disp(utility_history(:, 1:1:end))
    
    %Record state info for this particular trial
    state_linger_info = [state_linger_info, state_history(:, :)];
end

%Plot the histogram of where players spent their times
figure;
%Map 1,2,.. back to (S,S), (S,H), ...
C = categorical(state_linger_info(:, :),[1 2 3 4],{'(S,S)','(S,H)','(H,S)','(H,H)'});
histogram(C, 'FaceColor','c');
title(['Time Spent in each state'])
end

function [a] = get_BRwI_action(rho, state)
%Provides the joint action (row and col players) based on the Best Reply
%with Inertia Learning Rule
%
%INPUT: rho, the coin parameter (use rho higher than default 0.50)
%OUTPUT: a the joint action, where a{1} row's action and a{2} col's action
%
%NOTE: rho needs to be large since this is the probability with which a
%player will choose the best reply. Consequently, (1-rho) needs to be
%small since a player will repeat own actions with a low probability.
%
%t=1 actions should be randomly chosen

a{1} = 'NA';
a{2} = 'NA';

%Player 1 (Row Player)
coin = rand;
if coin < rho %a rho of 0.90
    if state==1
        a{1}='S';
    elseif state==2
        a{1}='H';
    elseif state==3
        a{1}='S';
    elseif state==4
        a{1}='H';
    end
else
    if state==1
        a{1}='S';
    elseif state==2
        a{1}='S';
    elseif state==3
        a{1}='H';
    elseif state==4
        a{1}='H';
    end
end

%Player 2 (Column Player)
coin = rand;
if coin < rho %a rho of 0.90
    if state==1
        a{2} = 'S';
    elseif state==2
        a{2}='S';
    elseif state==3
        a{2}='H';
    elseif state==4
        a{2}='H';
    end
else
    if state==1
        a{2}='S';
    elseif state==2
        a{2} = 'H';
    elseif state==3
        a{2}='S';
    elseif state==4
        a{2}='H';
    end
end

end

function [a] = get_random_action
%Provides the joint action (row and col players) based on random selection.
%Row player filps a "coin" paramterized by rho. Subsequently, Col player
%flips a "coin."
%INPUT: rho, the coin parameter
%OUTPUT: a the joint action, where a{1} row's action and a{2} col's action

a{1} = 'NA';
a{2} = 'NA';

coin = rand;
if coin <= 0.50 %a rho of 0.50
    a{1} = 'S';
else
    a{1} = 'H';
end

coin = rand;
if coin <= 0.50 %a rho of 0.50
    a{2} = 'S';
else
    a{2} = 'H';
end

end

%Helper function that spits out the utility of each player, given a joint
%action. For instance, evaluate({'S'; 'H'}), will return [0; 2], i.e., 0
%points for the row player and 2 points for the col player.
function [u] = get_utility(a)

u = zeros(2,1);

if strcmp(a{1}, 'S') && strcmp(a{2}, 'S')
    u = [3; 3];
end

if strcmp(a{1}, 'S') && strcmp(a{2}, 'H')
    u = [0; 2];
end

if strcmp(a{1}, 'H') && strcmp(a{2}, 'S')
    u = [2; 0];
end

if strcmp(a{1}, 'H') && strcmp(a{2}, 'H')
    u = [2; 2];
end

end

%Helper function that keeps track of state
%(S,S) -> 1, (S,H) -> 2, (H,S) -> 3, (H,H) -> 4
function [s] = get_state(a)

s = 0;

if strcmp(a{1}, 'S') && strcmp(a{2}, 'S')
    s = 1;
end

if strcmp(a{1}, 'S') && strcmp(a{2}, 'H')
    s = 2;
end

if strcmp(a{1}, 'H') && strcmp(a{2}, 'S')
    s = 3;
end

if strcmp(a{1}, 'H') && strcmp(a{2}, 'H')
    s = 4;
end

if(s==0)
    disp(a{1});
end

end


