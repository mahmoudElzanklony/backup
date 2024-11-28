<?php

namespace App\Http\Resources;

use App\Models\languages;
use App\Services\FormRequestHandleInputs;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CouponResource extends JsonResource
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
            'user'=>UserResource::make($this->whenLoaded('user')),
            'created_at'=>$this->created_at->format('Y-m-d H:i:s'),
            'expiration_at'=>$this->expiration_at,
            'serial'=>$this->serial,
            'max_number_of_users'=>$this->max_number_of_users,
            'type'=>$this->type,
            'value'=>$this->value,
            'max_value'=>$this->max_value,
        ];
        if(request()->hasHeader('AllLangs')){
            $langs = languages::query()->select('prefix')->get();
            // data
            $name = FormRequestHandleInputs::handle_output_column_for_all_lang('name',$this->name,$langs);
            return array_merge($init,$name);
        }else{
            $data = [
                'name'=>FormRequestHandleInputs::handle_output_column($this->name),
            ];
            return array_merge($init,$data);
        }
    }
}
