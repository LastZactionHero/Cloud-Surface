class DrawingsController < ApplicationController
  # GET /drawings
  # GET /drawings.xml
  def index
    @drawings = Drawing.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @drawings }
    end
  end

  # GET /drawings/1
  # GET /drawings/1.xml
  def show
    @drawing = Drawing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @drawing }
    end
  end

  # GET /drawings/new
  # GET /drawings/new.xml
  def new
    @drawing = Drawing.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @drawing }
    end
  end

  # GET /drawings/1/edit
  def edit
    @drawing = Drawing.find(params[:id])
  end

  # POST /drawings
  # POST /drawings.xml
  def create
    @drawing = Drawing.new(params[:drawing])

    respond_to do |format|
      if @drawing.save
        format.html { redirect_to(@drawing, :notice => 'Drawing was successfully created.') }
        format.xml  { render :xml => @drawing, :status => :created, :location => @drawing }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @drawing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /drawings/1
  # PUT /drawings/1.xml
  def update
    @drawing = Drawing.find(params[:id])

    respond_to do |format|
      if @drawing.update_attributes(params[:drawing])
        format.html { redirect_to(@drawing, :notice => 'Drawing was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @drawing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /drawings/1
  # DELETE /drawings/1.xml
  def destroy
    @drawing = Drawing.find(params[:id])
    @drawing.destroy

    respond_to do |format|
      format.html { redirect_to(drawings_url) }
      format.xml  { head :ok }
    end
  end
  
  # Fetch All Threads
  def fetch_threads
    @drawings = Drawing.all

    respond_to do |format|
      #format.xml  { render :xml => @drawings }
      format.xml { render :xml => @drawings, :except => [ :created_at, :updated_at ], :skip_types => true  }
    end
  
  end
  
  # Add New Thread
  def new_thread
    #?user=0&points=0,0,100,0,100,100,0,100,0,0
    
    # Get New Thread Index
    thread_idx = 0
    drawings = Drawing.find( :all, :order => "thread DESC" )
    if drawings.length > 0 then
      thread_idx = drawings[0][:thread] + 1 
    end
  
    # Get Thread Parameters
    user = params[:user]
    points = params[:points].split( ',' )
    point_count = points.length / 2
    
    # Build and Save Thread
    for i in ( 0..(point_count - 1) )
      x = points[2 * i]
      y = points[2 * i + 1]
      
      drawing = Drawing.new(params[:drawing])
      drawing.x = x;
      drawing.y = y;
      drawing.user = user;
      drawing.thread = thread_idx;
      drawing.save
    end
    
    puts "Thread Idx: #{thread_idx}"
    puts "User: #{user}"
    puts "Points: #{points}"
    puts "Point Count: #{point_count}"
    
    redirect_to :action => 'index'
  end
  
  # Clear Drawing
  def clear_all
    drawings = Drawing.all
    
    drawings.each do |drawing|
      drawing.destroy
    end
    
    redirect_to :action => 'index'
  end
end
