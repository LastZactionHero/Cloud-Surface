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
end
