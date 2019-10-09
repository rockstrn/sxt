function varargout = sxt_GUI(varargin)
% SXT_GUI MATLAB code for sxt_GUI.fig
%      SXT_GUI, by itself, creates a new SXT_GUI or raises the existing
%      singleton*.
%
%      H = SXT_GUI returns the handle to a new SXT_GUI or the handle to
%      the existing singleton*.
%
%      SXT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SXT_GUI.M with the given input arguments.
%
%      SXT_GUI('Property','Value',...) creates a new SXT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sxt_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sxt_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sxt_GUI

% Last Modified by GUIDE v2.5 22-Sep-2019 19:38:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sxt_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @sxt_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% 窗体打开前，先执行该函数
function UI_tupian_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

A=imread('im.jpg');   %读取图片
set(handles.pushbutton1,'CData',A);  %将按钮的背景图片设置成A，美化按钮

guidata(hObject, handles);



% --- Executes just before sxt_GUI is made visible.
function sxt_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sxt_GUI (see VARARGIN)

% Choose default command line output for sxt_GUI
handles.output = hObject;
ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'down')
colormap gray
set(ha,'handlevisibility','off','visible','off');

set(handles.axes15,'visible','off');
axes(handles.axes15);
image = imread('111.jpg');
imshow(image);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sxt_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = sxt_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

set(handles.axes1,'visible','off'); %不显示坐标框
set(handles.axes2,'visible','off');
set(handles.axes3,'visible','off');
set(handles.axes4,'visible','off');
set(handles.axes5,'visible','off');
set(handles.axes6,'visible','off');
%set(handles.axes7,'visible','off');



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imaqhwinfo('winvideo');
global vid1;
global vid2;
vid1 = videoinput('winvideo',2,'YUY2_720x576'); %创建ID为1的摄像头的视频对象，视频格式是YUY2_360x288，这表示视频的分辨率为360x288。其他会卡 YUY2_640x480
vid2 = videoinput('winvideo',3,'RGB24_1280x960'); %创建ID为2的摄像头的视频对象，视频格式是YUY2_640x480，这表示视频的分辨率为640x480。 
vid2.ROIPosition = [12 33 1216 894]; %[距左,距右,长,宽]
set(vid1,'ReturnedColorSpace','rgb');               %在这里设置不会出现红色视频(如果没有照出的照片是红色）
set(vid2,'ReturnedColorSpace','rgb');          %'grayscale'将视频变为黑白  
usbVidRes1=get(vid1,'videoResolution'); %视频分辨率
usbVidRes2=get(vid2,'videoResolution'); %视频分辨率
nBands1=get(vid1,'NumberOfBands');      %摄像头数据的通道数
nBands2=get(vid2,'NumberOfBands');      %摄像头数据的通道数
axes(handles.axes6);  
hImage1=imshow(zeros(usbVidRes1(2),usbVidRes1(1),nBands1));  %以hImage的尺寸显示摄像头数据
hImage1=fliplr(hImage1(:,:));
preview(vid1,hImage1);
axes(handles.axes5);  
hImage2=imshow(zeros(usbVidRes2(2),usbVidRes2(1),nBands2));  %以hImage的尺寸显示摄像头数据
preview(vid2,hImage2);
global I2;
while(1)
    frame1=getsnapshot(vid1);
    frame2=getsnapshot(vid2);
    I=imresize(frame1,[196,228]);      %将两个摄像头全定义为196x228像素
    T=imresize(frame2,[196,228]);      %将两个摄像头全定义为196x228像素
    I1=rgb2gray(I);
    T1=rgb2gray(T);
    I2=fliplr(I1(:,:));
    pause(0.033);            %停止函数，一秒三十帧
    axes(handles.axes2);
    imshow(I2)
    axes(handles.axes1);
    imshow(T1)
end;   



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global vid1;
global vid2;
global var5;
var=get(handles.popupmenu1,'value');

switch var
     case 2                                        %红外
        h1=[handles.edit1];
        set(h1,'Visible','off');
        h2=[handles.slider3 handles.edit3];
        set(h2,'Visible','on');
        while(1)
            frame1=getsnapshot(vid1);
            frame2=getsnapshot(vid2);
            frame1=rgb2gray(frame1);           %不用这个会出现红色
            frame2=rgb2gray(frame2);           %不用这个会出现红色
            frame1=fliplr(frame1(:,:));   %镜像红外
            I=imresize(frame1,[196,228]);      %将两个摄像头全定义为196x228像素
            T=imresize(frame2,[196,228]);
            axes(handles.axes2);
            imshow(I)
            axes(handles.axes1);
            imshow(T)
            im=I;
            im=im2double(im);
            I=im2double(I);
            T=im2double(T);
            for p=1:196
                for j=1:228
                   im(p,j)=(var5/100*I(p,j)+((100-var5)/100*T(p,j)))/2;
                end
            end
            %pause(0.033);            %停止函数，一秒三十帧
            axes(handles.axes3);
            imshow(im)
            set(handles.edit1,'string','红外权值为%');
        end;
    case 3
        h1=[handles.edit1 handles.edit2];
        set(h1,'Visible','on');
        h2=[handles.text16 handles.text15 handles.edit3];
        set(h2,'Visible','off');
        while(1)
            h2=[handles.slider3 handles.edit3];
            set(h2,'Visible','off');
            frame3=getsnapshot(vid1);
            frame4=getsnapshot(vid2);
            I1=imresize(frame3,[196,228]);      %将两个摄像头全定义为196x228像素
            T1=imresize(frame4,[196,228]);
            I1 = double(rgb2gray(I1))/255;         %小波需要这个吗
            I1=fliplr(I1(:,:));
            T1 = double(rgb2gray(T1))/255;         %小波需要这个吗

            Y_wt=wtfusion(I1,T1,2,'db1'); 
            axes(handles.axes2);
            imshow(I1)
            axes(handles.axes1);
            imshow(T1)

            axes(handles.axes3);
            imshow(Y_wt);
            set(handles.edit1,'string','哈哈');
            set(handles.edit2,'string','使用a波');
        end
        clear all;
    case 4
        h1=[handles.edit1 handles.edit2];
        set(h1,'Visible','on');
        h2=[handles.text16 handles.text15 handles.edit3];
        set(h2,'Visible','off');
        while(1)
            h2=[handles.slider3 handles.edit3];
            set(h2,'Visible','off');
            frame1=getsnapshot(vid1);
            frame2=getsnapshot(vid2);
            I=imresize(frame1,[196,228]);      %将两个摄像头全定义为196x228像素
            T=imresize(frame2,[196,228]);
            I = double(rgb2gray(I))/255;         %小波需要这个吗
            I=fliplr(I(:,:));
            T = double(rgb2gray(T))/255;         %小波需要这个吗

            axes(handles.axes2);
            imshow(I)
            axes(handles.axes1);
            imshow(T)
            mp = 1;zt =4; cf =1;ar = 1; cc = [cf ar]; 

            Y_con=fuse_con(I,T,zt,cc,mp); 

            axes(handles.axes3);
            imshow(Y_con);

        end
clear all;
    case 5
        h2=[handles.text16 handles.text15 handles.edit3];
        set(h2,'Visible','off');
        h1=[handles.edit1 handles.edit2];
        set(h1,'Visible','on');
        while(1)
            h2=[handles.slider3 handles.edit3];
            set(h2,'Visible','off');
            frame1=getsnapshot(vid1);
            frame2=getsnapshot(vid2);

            I=imresize(frame1,[196,228]);      %将两个摄像头全定义为196x228像素
            T=imresize(frame2,[196,228]);
            I = double(rgb2gray(I))/255;         %小波需要这个吗
            I=fliplr(I(:,:));
            T = double(rgb2gray(T))/255;         %小波需要这个吗

            axes(handles.axes2);
            imshow(I)
            axes(handles.axes1);
            imshow(T)
            mp = 1;zt =4; cf =1;ar = 1; cc = [cf ar]; 

            Y_lap = fuse_lap(I,T,zt,cc,mp); 

            axes(handles.axes3);
            imshow(Y_lap);

        end

        
        
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global var5
var5=get(handles.slider3,'value');
set(handles.edit3,'string',num2str(var5));




% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h2=[ handles.text17];
set(h2,'Visible','off');
h2=[ handles.text12];
set(h2,'Visible','on');

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h2=[handles.text12];
set(h2,'Visible','off');
h2=[ handles.text17];
set(h2,'Visible','on');

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
