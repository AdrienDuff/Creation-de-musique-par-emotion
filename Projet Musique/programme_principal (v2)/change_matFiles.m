function y = change_matFiles(name)
  data = load(name);
  new_name = [name(1:length(name)-4),'_bin.mat']
  save(new_name,'data','-mat7-binary')
  end