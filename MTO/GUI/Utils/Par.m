classdef Par < handle
  % Par  TIC-TOC class for parfor loops
  %   This is a class for timing PARFOR loops. Once the measurement is
  %   made, it can be plotted to observe the various overheads that may
  %   exist in parallel for loops. It also shows the utilization of each
  %   worker.
  %
  % Par Properties:
  %  Worker       - Process ID of the worker
  %  ItStart      - Start time of iteration
  %  ItStop       - Stop time of iteration
  %
  % Par Methods:
  %  Par          - Construct Par objects and start the measurement
  %  stop         - Stop the measurement
  %  par2struct   - Convert the results to a flat structure
  %  plot         - Create a custom plot of the results
  %  horzcat      - Horizontally concatenate multiple PARFOR measurements
  %  StartTime    - Return the start time of the measurement
  %  StopTime     - Return the stop time of the measurement
  %  tic (Static) - Record start time of parfor loop iteration
  %  toc (Static) - Record stop time of parfor loop iteration
  %
  % This class should be used in the following way:
  %
  %       p = Par(n);                   (1)
  %       parfor id = 1:n
  %           Par.tic;                  (2)
  %
  %           <usual computations>
  %
  %           p(id) = Par.toc;          (3)
  %       end
  %       stop(p);                      (4)
  %
  %       plot(p);                      (5)
  %
  % 1. Construct a Par object, with the number of iterations as the input.
  %    This constructs the object.
  % 2. Call Par.tic just inside the PARFOR loop. This records the start
  %    time of the iteration.
  % 3. Call Par.toc just before the end of the PARFOR loop. Store the
  %    output to the appropriate index of the Par object. This is necessary
  %    for PARFOR to recognize that the variable is sliced.
  % 4. Stop the measurement. This records the final end time.
  % 5. Visualize.
  %
  % There may be some overhead in adding the Par construct. Because of
  % this, the numbers you get may not accurately portray the true timing,
  % especially for short computations.
  %
  % Doc page in Help browser
  %   <a href="matlab:doc Par">doc Par</a>
  
  % Copyright 2010 The MathWorks, Inc.
  
  properties (SetAccess = protected)
    % WORKER  Process ID of the worker running this iteration
    %   This is a read-only property and is only set using Par.tic and
    %   Par.toc
    Worker = NaN
    
    % ITSTART  Start time (from the start of object creation) of the iteration
    %   This is a read-only property and is only set using Par.tic and
    %   Par.toc
    ItStart = NaN
    
    % ITSTOP  Stop time (from the start of object creation) of the iteration
    %   This is a read-only property and is only set using Par.tic and
    %   Par.toc
    ItStop = NaN
  end
  
  properties (Hidden, GetAccess = protected)
    MainStartTime = []
    MainStopTime  = []
  end
  
  methods
    
    function obj = Par(n, varargin)
      % PAR Contructor for the Par object
      %
      % obj = Par(N)
      %   Creates an array of loop timer object for PARFOR loops. N is a
      %   positive integer equal to the length of iterations in the PARFOR
      %   loop.
      
      % Special case used internally
      %   check first since we want this to happen immediately.
      if nargin == 3
        obj.Worker  = n;
        obj.ItStart = varargin{1};
        obj.ItStop  = varargin{2};
        return;
      end
            
      switch nargin
        case 0
          return;
          
        case 1
          validateattributes(n, {'numeric'}, {'integer', 'scalar', 'positive'});
          obj(n) = Par();
          
          % Record the current time
          getnow(1);
          
          % Start the initial tic on this machine and on the workers
          tictoc(1);
          spmd
            tictoc(1);
          end
          
        otherwise
          error('Par:Par:InvalidNumberOfInputArguments', ...
            'You must call the constructor with one input argument: Par(n)');
      end
            
    end
    
    function newobj = horzcat(varargin)
      % HORZCAT Horizontally concatenate multiple PARFOR measurements.
      %
      % horzcat(p1, p2, ...) or [p1, p2, ...]
      %   Concatenates multiple Par objects. This allows you to combine
      %   results from multiple PARFOR blocks that are run sequentially.
      %   P1, P2, ... must be either Par objects or an empty array ([]).
      
      varargin(cellfun(@isempty, varargin)) = [];
      
      if ~all(cellfun('isclass', varargin, 'Par'))
        error('Par:horzcat:InvalidInputType', ...
          'Input arguments must [] or class type Par');
      end
      
      % Sort Par objects by MainStartTime
      [sortedGlobalTimes, idx] = sort(cellfun(@(x) min([x.MainStartTime]), varargin));
      % Calculate time to offset each Par objects
      offset = (sortedGlobalTimes - sortedGlobalTimes(1))*24*3600;
      
      % Reorder in ascending MainStartTime
      varargin = varargin(idx);

      % Create a new Par object with the appropriate number of elements
      num = sum(cellfun(@length, varargin));
      newobj = Par(num);
      
      % Concatenate one by one, offsetting the times by the offset values
      iCounter = 0;
      for iPar = 1:length(varargin)
        idx = (1:length(varargin{iPar})) + iCounter;
        os = offset(iPar);
        
        [newobj(idx).Worker]        = deal(varargin{iPar}.Worker);
        [newobj(idx).MainStartTime] = deal(varargin{iPar}.MainStartTime);
        [newobj(idx).MainStopTime]  = deal(varargin{iPar}.MainStopTime);
        
        newobj(idx(end)).MainStopTime = newobj(idx(end)).MainStopTime + os;
        
        newval = num2cell([varargin{iPar}.ItStart] + os);
        [newobj(idx).ItStart] = deal(newval{:});
        newval = num2cell([varargin{iPar}.ItStop] + os);
        [newobj(idx).ItStop] = deal(newval{:});
        
        iCounter = iCounter + length(varargin{iPar});
      end
            
    end
    
    function stop(obj)
      % STOP Stop the measurement.
      %
      % obj.stop() or stop(obj)
      %   Stops the measurement process. This should be called right after
      %   the parfor loop.
      
      if ~isempty(obj(end).MainStopTime)
        error('Par:stop:MultipleStopsNotAllowed', ...
          'You cannot stop more than once.');
      end
      
      % Assign only to the last element to minimize memory usage.
      obj(end).MainStartTime = getnow(2);
      obj(end).MainStopTime  = tictoc(2);                       %#ok<NASGU>
      
    end
    
    function val = StartTime(obj)
      % STARTTIME Return the end time of the measurement.
      %
      % val = obj.StartTime() or val = StartTime(obj)
      %   Returns the start time relative to the initial creation of the
      %   object. Usually, this is zero. If this object was a concatenation
      %   of multiple Par objects, then this will return multiple start
      %   times for each of the objects, relative to the initial start
      %   time.
      
      % The start time is stored in the hidden property MainStartTime
      gst = [obj.MainStartTime];
      % Convert to seconds (MainStartTime is a serial date)
      val = (gst - gst(1)) * 24 * 3600;
      
    end
    
    function val = StopTime(obj)
      % STOPTIME Return the end time of the measurement.
      %
      % val = obj.StopTime() or val = StopTime(obj)
      %   Returns the time passed from the creation of the object to
      %   stopping of the object.
      
      % The stop time is stored in the hidden property MainStopTime
      val = [obj.MainStopTime];
      
    end
    
    function parInfo = par2struct(obj)
      % PAR2STRUCT Convert the results to a flat structure.
      %
      % p = obj.par2struct() or p = par2struct(obj)
      %   Converts the results into a flat structure with the following
      %   fields:
      %       Start   : start times of each PARFOR block
      %       Stop    : end times of each PARFOR block
      %       Worker  : array of process id's for each iteration
      %       ItStart : array of start times for each iteration
      %       ItStop  : array of stop times for each iteration
      
      parInfo.Start   = obj.StartTime;
      parInfo.Stop    = obj.StopTime;
      parInfo.Worker  = [obj.Worker];
      parInfo.ItStart = [obj.ItStart];
      parInfo.ItStop  = [obj.ItStop];
      
    end
    
    function plot(obj, varargin)
      % PLOT Create a custom plot of the results.
      %
      % obj.plot() or plot(obj)
      %   Creates a custom plot of the results. The plot consists of 3
      %   parts:
      %     1) a line graph showing start and stop times of each iteration
      %     on each worker.
      %     2) a stacked bar graph showing the efficiency of each worker.
      %     3) a plot showing actual duration of each iteration.
      %
      % obj.plot(obj2) or plot(obj, obj2)
      %   Creates a custom plot that also compares the results of obj and
      %   obj2. obj2 must be of class Par and must be a result from a
      %   serial computation or a single-worker computation.
      
      % Error checking
      addSerial = 0;
      
      if nargin == 3
        
        obj2 = varargin{1};
        newMap = varargin{2};
        addSerial = 1;
        if ~isa(newMap, 'function_handle')
          error('Par:plot:invalidclass', ...
            'The third argument must be a function handle');
        end
        
      end
      
      if nargin == 2
        
        if isa(varargin{1}, 'function_handle')
          newMap = varargin{1};
        else
          obj2 = varargin{1};
          addSerial = 1;
          if ~(isa(obj2, 'Par'))
            error('Par:plot:invalidclass', ...
              'The second argument must also be of class Par or a function handle');
          end
          
          if length(unique([obj2.Worker])) > 1
            error('Par:plot:notserial', ...
              'The second argument must be the results from a serial (or 1 worker) calculation');
          end
        end
        
      end
      
      if any(isnan(obj.StopTime)) || (addSerial == 1 && isnan(obj2.StopTime))
        error('Par:plot:unterminated', ...
          'You need to stop() the object before you can plot()');
      end
      
      if any(isnan([obj.Worker])) || (addSerial == 1 && any(isnan([obj.Worker])))
        error('Par:plot:uncompleted', ...
          'You need to have timed all iterations before you can plot()');
      end
      
      % Call plotting subfunction
      if nargin == 1
        parPlot(addSerial, obj.par2struct)
      elseif nargin == 2
        if addSerial == 1
          parPlot(addSerial, obj.par2struct, obj2.par2struct)
        else
          parPlot(addSerial, obj.par2struct, newMap)
        end
      else
        parPlot(addSerial, obj.par2struct, obj2.par2struct, newMap)
      end
      
    end
    
  end
  
  methods (Static)
    
    function val = tic()
      % TIC Record start time of parfor loop iteration.
      %
      % Par.tic()
      %   Records the starting time within the loop. This should be called
      %   immediately inside the parfor loop.
      %
      % See also Par.toc
      
      persistent start_time
      
      if nargout
        if isempty(start_time)
          val = NaN;
        else
          val = start_time;
        end
      else
        start_time = tictoc(2);
      end
      
    end
    
    function obj = toc()
      % TOC Record stop time of parfor loop iteration.
      %
      % obj = Par.toc()
      %   Records the ending time within the loop. This should be called
      %   just before the end statement of the parfor loop.
      %
      % See also Par.tic
      
      if nargout
        
        workerNo = get(getCurrentTask,'ID');
        
        if isempty(workerNo)
          workerNo  = 0;
        end
        
        obj = Par(workerNo, Par.tic(), tictoc(2));
        
      end
      
    end
    
  end
  
  % These are overridden handle class methods. It's hidden so that it
  % doesn't show up as one of the standard methods in the DOC.
  methods (Hidden)
    
    function varargout = vertcat(varargin) %#ok<STOUT>
      
      error('Par:vertcat:VerticalConcatenationNotAllowed', ...
        ['Vertical concatenation is not allowed for a Par object.\n', ...
        'Consider horizontal concatenation.']);
      
    end

    function out = addlistener(varargin)
      out = addlistener@handle(varargin{:});
    end
    
    function delete(varargin)
      delete@handle(varargin{:});
    end
    
    function out = eq(varargin)
      out = eq@handle(varargin{:});
    end
    
    function findobj(varargin)
      findobj@handle(varargin{:});
    end
    
    function out = findprop(varargin)
      out = findprop@handle(varargin{:});
    end
    
    function out = ge(varargin)
      out = ge@handle(varargin{:});
    end
    
    function out = gt(varargin)
      out = gt@handle(varargin{:});
    end
    
    function out = le(varargin)
      out = le@handle(varargin{:});
    end
    
    function out = lt(varargin)
      out = lt@handle(varargin{:});
    end
    
    function out = ne(varargin)
      out = ne@handle(varargin{:});
    end
    
    function notify(varargin)
      notify@handle(varargin{:})
    end
    
  end
  
end

function out = getnow(flag)
% getnow
%   Internal function for recording global start time (in serial dates).

persistent nowtime

switch flag
  case 1
    nowtime = now;
  case 2
    if isempty(nowtime)
      error('Par:getnow:InvalidInitialization', ...
        ['The Par object may not have been initialized correctly.\n', ...
        'Be sure to initialize Par object with an input argument: p = Par(n)']);
    else
      out = nowtime;
    end
end

end

function out = tictoc(flag)
% tictoc
%   Internal function for recording start and end times.

persistent t1

switch flag
  case 1
    t1 = tic;
  case 2
    if isempty(t1)
      error('Par:tictoc:InvalidInitialization', ...
        ['The Par object may not have been initialized correctly.\n', ...
        'Be sure to initialize Par object with an input argument: p = Par(n)']);
    else
      out = toc(t1);
    end
  case 3
    if isempty(t1)
      error('Par:tictoc:InvalidInitialization', ...
        ['The Par object may not have been initialized correctly.\n', ...
        'Be sure to initialize Par object with an input argument: p = Par(n)']);
    else
      out = t1;
    end
end

end

function  parPlot(addSerial, parInfo, varargin)

cMap = @winter;

if nargin == 4
  parInfoS = varargin{1};
  cMap = varargin{2};
end

if nargin == 3
  if addSerial
    parInfoS = varargin{1};
  else
    cMap = varargin{1};
  end
end

% Determing unique workers
pid = parInfo.Worker;
allPIDs = unique(parInfo.Worker);
numWorkers = length(allPIDs);

% Preallocation
startTimes = cell(1, numWorkers);
endTimes = cell(1, numWorkers);
itTimes = cell(1, numWorkers);
totalTimes = nan(1, numWorkers);
overHead = nan(1, numWorkers);
overPerct = nan(1, numWorkers);
avgLoopTime = nan(1, numWorkers);

% Extracting start times, end times, and iteration times
if addSerial
  startTimesS = parInfoS.ItStart;
  endTimesS = parInfoS.ItStop;
  itTimesS = parInfoS.ItStop - parInfoS.ItStart;
  speedUp = parInfoS.Stop/parInfo.Stop;
end

totalParTime = sum(parInfo.Stop - parInfo.Start);

for ii = 1:numWorkers
  myIndex = (pid == allPIDs(ii));
  
  startTimes{ii} = parInfo.ItStart(myIndex);
  endTimes{ii} = parInfo.ItStop(myIndex);
  itTimes{ii} = parInfo.ItStop(myIndex) - parInfo.ItStart(myIndex);
  totalTimes(ii) = sum(endTimes{ii}-startTimes{ii});
  
  overHead(ii) = totalParTime-totalTimes(ii);
  overPerct(ii) = (overHead(ii)/totalParTime)*100;
  avgLoopTime(ii) = totalTimes(ii)/length(endTimes{ii});
end

% Plotting Data

myColors = cMap(numWorkers+addSerial); % setting up color scheme

hFig = figure;
subplot(2, 2, 1:2, 'Parent', hFig);
box on;

if addSerial
  plotdata = [startTimesS;endTimesS;nan(1, length(startTimesS))];
  plotdata2 = startTimesS;
  plotdata3 = endTimesS;
  
  line(plotdata(:), zeros(1, numel(plotdata)), ...
    'color', myColors(1,:));
  hold on
  line(plotdata2(:), zeros(1, numel(plotdata2)), ...
    'marker','.','MarkerSize',5, 'LineStyle', 'none',...
    'color', myColors(1,:));
  hold on
  line(plotdata3(:), zeros(1, numel(plotdata3)), ...
    'marker','X','MarkerSize',5, 'LineStyle', 'none',...
    'color', myColors(1,:));
  
  speedStr=['Speed Up = ', num2str(speedUp)];
  text(parInfo.Stop + (0.005*parInfo.Stop),numWorkers,speedStr)
end

for ii = 1:numWorkers
  plotdata = [startTimes{ii};endTimes{ii};nan(1, length(startTimes{ii}))];
  plotdata2 = startTimes{ii};
  plotdata3 = endTimes{ii};
  
  line(plotdata(:), ii*ones(1, numel(plotdata)), ...
    'color', myColors(ii+addSerial,:));
  hold on
  line(plotdata2(:), ii*ones(1, numel(plotdata2)), ...
    'marker','.','MarkerSize',5, 'LineStyle', 'none', ...
    'color',myColors(ii+addSerial,:));
  hold on
  line(plotdata3(:), ii*ones(1, numel(plotdata3)), ...
    'marker','X','MarkerSize',5, 'LineStyle', 'none', ...
    'color', myColors(ii+addSerial,:));
  
end

% Plotting total start and stop times

line([parInfo.Start; parInfo.Start], ...
  repmat([0-addSerial; (numWorkers+1)], 1, length(parInfo.Start)),...
  'color', [.5 .5 .5]);
line([parInfo.Stop; parInfo.Stop], ...
  repmat([0-addSerial; (numWorkers+1)], 1, length(parInfo.Stop)),...
  'color', [.5 .5 .5]);
line([0 0], [0-addSerial, (numWorkers+1)], 'color', 'k');
ylim([0-addSerial (numWorkers+1)])
set(gca, 'YTick', (1-addSerial):numWorkers);
set(gca, 'TickDir', 'out');

if addSerial == 1
  % Setting 0 label to Serial for clarity
  ylabels = get(gca, 'YTickLabel') ;
  newlabels = char(zeros(length(ylabels),6));
  newlabels(:,1) = ylabels;
  newlabels(1,:) = 'Serial';
  set(gca, 'YTickLabel', newlabels) ;
end

title('Iterations in Time By Worker','fontweight','b')
xlabel('Time (s)')
ylabel('Worker')

% Plotting Efficency
subplot(2,2,3)

if numWorkers > 1
  
  % Giving bars different colors
  for ii = 1:numWorkers
    pp = nan(numWorkers, 2);
    pp(ii, :) = [100-overPerct(ii), overPerct(ii)];
    hB = barh(1:numWorkers, pp, 'stack');
    set(hB(1),'FaceColor',myColors(addSerial+ii,:));
    set(hB(2),'FaceColor',[0.5 0.5 0.5]);
    hold on;
  end
  
else
  hB = barh( [1 2] ,[100-overPerct, NaN; overPerct, NaN]','Stack');
  set(hB(1),'FaceColor',myColors(1,:));
  set(hB(2),'FaceColor',[0.5 0.5 0.5])
end

ylim([0, numWorkers+1])
set(gca, 'YTick', 1:numWorkers);

title('Worker Utilization','fontweight','b')
xlabel('% of Total Time on Worker')
ylabel('Worker')

% Plotting Stats on Iteration Times
% Adding menu to change between linear and semilog axis
hMenu = uicontextmenu();
hAx = subplot(2,2,4, 'UIContextMenu', hMenu);
uimenu('Parent', hMenu, 'Label', 'Linear Scale', 'Checked', 'on', ...
  'Callback', {@setScaleFcn, hAx});
uimenu('Parent', hMenu, 'Label', 'Log Scale', 'Checked', 'off', ...
  'Callback', {@setScaleFcn, hAx});

if addSerial
  counter = (1:length(parInfo.ItStop));
  plot(counter,itTimesS,'color', ...
    myColors(1,:),'Marker','.','LineStyle','none')
  hold on
end

for ii = 1:numWorkers
  myIndex = (pid == allPIDs(ii));
  counter = (1:length(parInfo.ItStop));
  plot(counter(myIndex),itTimes{ii},'color', ...
    myColors(ii+addSerial,:),'Marker','*','LineStyle','none')
  hold on
end

title('Time Of Individual Iterations','fontweight','b')
xlabel('Iteration Number')
ylabel('Iteration Time (s)')

set(hFig, 'HandleVisibility', 'off');

% if numWorkers + addSerial > 1
%     % Add legend if more than one point
%     legendTxt = cell(addSerial+numWorkers,1);
%
%     for ii = 1-addSerial:numWorkers
%         legendTxt{ii+addSerial,1} = num2str(ii);
%     end
%
%     legend(legendTxt)
%
% end
end

function setScaleFcn(hObject, ~, hAx)

set(get(get(hObject, 'Parent'), 'Children'), 'Checked', 'off')
set(hObject, 'Checked', 'on');
switch get(hObject, 'Label')
  case 'Log Scale'
    set(hAx, 'YScale', 'log');
  case 'Linear Scale'
    set(hAx, 'YScale', 'linear');
end

end


