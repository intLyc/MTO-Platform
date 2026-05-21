function som_show_clear(type, p)

%SOM_SHOW_CLEAR Clear hit marks, labels or trajectories from current figure. 
%
% som_show_clear([type], [p])
% 
%  som_show_clear
%  som_show_clear('Traj',[1 2])
% 
% Input arguments ([]'s are optional):        
%  [type] (string) which markers to delete (case insensitive)
%                  'hit'   to remove hit marks
%                  'lab'   to remove labels
%                  'traj'  to remove line trajectories
%                  'comet' to remove comet trajectories
%                  'all'   to remove all (the default)
%  [p]    (vector) subplot number vector 
%         (string) 'all' for all subplots (the default)
%
% This function removes the objects made by SOM_SHOW_ADD from a
% figure.  If no value is given for p, the function operates on every
% axis in the current figure. It simply searches for the objects with
% certain values in the 'Tag' field. It does not matter if the figure
% objects are created by SOM Toolbox -functions or not. However, if
% vector p or string 'all' _is_ given, the figure has to have been
% created by SOM_SHOW.
%  
% For more help, try 'type som_show_clear' or check out the helpdesk.
% See also SOM_SHOW_ADD, SOM_SHOW.

%%%%%%%%% DETAILED DESCRIPTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% som_show_clear
%
% PURPOSE
%
% Clear hit marks, labels or trajectories created by SOM_SHOW_ADD
% from the current figure. 
%
% SYNTAX
% 
%  som_show_clear
%  som_show_clear([type],[p])
%
% DESCRIPTION
%
% The function SOM_SHOW_ADD creates some markers on the top of
% visualizations made by SOM_SHOW. These objects may be removed using
% SOM_SHOW_CLEAR even if the object handles are not known. The function
% removes the objects based on certain tags written to the 'Tag' property
% field of the objects.
%
% If the function if called without input arguments it searches for
% every object in the current figure that have string
% 'Hit','Lab','Traj' or 'Comet' in their Tag property field and
% deletes them.
%
% If input argument p is not specified, the function does not check that the
% figure is created by function SOM_SHOW.
%
% OPTIONAL INPUT ARGUMENTS
%
% type  (string) Which type of markers to delete
%                'Hit' for removing hit marks    
%                'Lab'              labels 
%                'Traj'             line trajectories 
%                'Comet'            comet trajectories 
%                'All'              all (the default)
%                Strings are case insensitive.
%
% p     (vector) Subplots from which the markers are removed
%                Specifies the subplots from which the markers are removed. 
%                The valid values are 1...N where N is the number of subplots. 
%                It is required that the figure has been created by 
%                the SOM_SHOW function.
%
% EXAMPLES 
%          
%   som_show_clear;
%      % deletes all labels, hit marks and trajectories in the figure
%   som_show_clear('hit');
%      % deletes all the hit marks in the current figure
%   som_show_clear('lab',[1 2]);
%      % deletes labels in SOM_SHOW figure subplots 1 and 2. 
%
% SEE ALSO
%
% som_show       Basic map visualizations: component planes, u-matrix etc.
% som_show_add   Show hits, labels and trajectories on SOM_SHOW visualization.

% Copyright (c) 1997-2000 by the SOM toolbox programming team.
% http://www.cis.hut.fi/projects/somtoolbox/             

% Version 1.0beta Johan 061197 
% Version 2.0beta Johan 061099 juuso 181199

%%% Check number of arguments

error(nargchk(0,2, nargin))     % check no. of input args is correct

%%% Initialize & check & action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0 || isempty(type) || strcmp(type,'all') % delete everything 
                                                    % in the gcf
  delete(findobj(gcf,'Tag','Hit'));
  delete(findobj(gcf, 'Tag','Lab'));
  delete(findobj(gcf, 'Tag','Traj'));
  delete(findobj(gcf, 'Tag','Comet'));
  return
end

if nargin < 2 || isempty(p)            % check handles
  handle=gcf;                       
else                                  % check subplot handles if p is given
  [handle,msg]=vis_som_show_data(p,gcf);
  if ~isempty(msg)
    error('2nd argument invalid or figure not made by SOM_SHOW: try SOM_SHOW_CLEAR without arguments.');
    end
end

switch lower(type)                    % check type & make proper tag names
case 'hit'  
  tag = 'Hit'; 
case 'lab'
  tag = 'Lab';
case 'traj'
  tag = 'Traj';                     
case 'comet'
  tag = 'Comet';
otherwise                             
  error('Invalid object tag. Must be {lab | hit | traj | comet}');
end

%%% Action %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(handle),
  h=findobj(handle(i),'Tag',tag);     % find object handles 
  delete(h);                          % delete objects
end				

%%% No output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

