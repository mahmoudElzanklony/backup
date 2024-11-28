<?php

namespace App\Http\Resources;

use App\Models\languages;
use App\Services\FormRequestHandleInputs;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CategoryResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $init = [
            'id'=>$this->id,
            'image'=>ImageResource::make($this->image),
            'parent_id'=>$this->parent_id,
            'parent'=>CategoryResource::make($this->whenLoaded('parent')),
            'properties'=>PropertyResource::collection($this->whenLoaded('properties')),
            'created_at'=>$this->created_at->format('Y-m-d H:i:s'),
        ];
        if(request()->hasHeader('AllLangs')){
            $langs = languages::query()->select('prefix')->get();
            // data
            $name = FormRequestHandleInputs::handle_output_column_for_all_lang('name',$this->name,$langs);
            $info = FormRequestHandleInputs::handle_output_column_for_all_lang('info',$this->info,$langs);
            if($info == "") return array_merge($init,$name);
            return array_merge($init,$name,$info);
        }else{
            $data = [
                'name'=>FormRequestHandleInputs::handle_output_column($this->name),
                'info'=>FormRequestHandleInputs::handle_output_column($this->info),
            ];
            if($data['info'] == "") return array_merge($init,$data['name']);
            return array_merge($init,$data);
        }

    }
}
