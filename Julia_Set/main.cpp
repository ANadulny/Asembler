#include <SDL2/SDL.h>
#include <iostream>


extern "C" { void countJuliaAsm(float imgWidth, float imgHeight, float startX, float endX, float startY, float endY, float C_Re,float C_Im ,unsigned int *pixels); }


void countJulia(float imgWidth, float imgHeight, float startX, float endX, float startY, float endY, float C_Re,float C_Im ,unsigned int *pixels)
{
    const int ITERATION = 100;
    float width = endX - startX;
    float ratioX = width / imgWidth;

    float height = endY - startY;
    float ratioY = height / imgHeight;

    std::cout<<"Ratio X: "<< ratioX <<"| RatioY "<< ratioY <<std::endl;

    for(int x = 0; x < imgWidth; x++)
    {
	for(int y = 0; y < imgHeight; y++)
	{
		float z_re = x * ratioX + startX;
		float z_im = y*ratioY + startY;
		float tmp_re = 0, tmp_im = 0;
		int lim = 4;
            	int iterations = ITERATION;
			
		for(; iterations > 0; iterations--)
		{
			tmp_re = z_re*z_re - z_im * z_im + C_Re;
			tmp_im = 2 * z_re * z_im + C_Im;
			z_re = tmp_re;
			z_im = tmp_im;

			if( (z_re*z_re + z_im*z_im)>(float)lim )
                    		break;
		}
		int index = y*imgWidth+x;
		int tmp = ITERATION - iterations;

            	if(iterations == 0)
			pixels[index] = 0xFF000000;

            	else if(tmp == 0)
			pixels[index] = 0xFFC71585;

            	else if(tmp == 1)
			pixels[index] = 0xFF8B0000;
            	
            	else if(tmp == 2)
			pixels[index] = 0xFFFF4500;

            	else if(tmp < 7)
			pixels[index] = 0xFFFFD700;

		else if(tmp < 16)
			pixels[index] = 0xFFADD8E6;
          
            	else if(tmp < 26 )           		
			pixels[index] = 0xFF0000FF;

            	else if(tmp < 51 )
			pixels[index] = 0xFFDB7093;
	}
    }
}


int main(int argc, char ** argv)
{
    if(argc < 4)
    {
        std::cout<<"Usage: "<<argv[0]<<" <width> <height> <C Re> <C Im>\n";
        return 1;
    }
    int imageWidth,imageHeight;
    float C_Re, C_Im;
    //int c_counter = 0;
    //float creal_table[5] = {-0.75, 0, 0, -0.123, -0.5}; 
    //float cimagine_table[5] = {0, 1, 0, 0.745, 0.5}; 

    imageWidth = atoi(argv[1]);
    imageHeight = atoi(argv[2]);
    C_Re = atof(argv[3]);
    C_Im = atof(argv[4]);
    std::cout<<"Image dimensions: "<<imageWidth<<" x "<<imageHeight<<std::endl;

    bool quit = false;
    SDL_Event event;

    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window * window = SDL_CreateWindow("SDL2 Julia Set",
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, imageWidth, imageHeight, 0);

    SDL_Renderer * renderer = SDL_CreateRenderer(window, -1, 0);
    SDL_Texture * texture = SDL_CreateTexture(renderer,
        SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STATIC, imageWidth, imageHeight);
    Uint32 *pixels = new Uint32[imageWidth * imageHeight];
    srand(time(NULL));
    memset(pixels, 255, imageWidth * imageHeight * sizeof(Uint32)); //set pixel array to white
    float startX = -2.0, startY = -2.0, endX = 2.0, endY = 2.0;

    countJuliaAsm(imageWidth,imageHeight,startX,endX,startY,endY, C_Re, C_Im ,pixels);

    while (!quit)
    {
        SDL_UpdateTexture(texture, NULL, pixels, imageWidth * sizeof(Uint32));
        SDL_WaitEvent(&event);

        switch (event.type)
        {
        case SDL_MOUSEBUTTONUP:
            memset(pixels, 255, imageWidth * imageHeight * sizeof(Uint32)); //set pixel array to white
            if (event.button.button == SDL_BUTTON_LEFT)
            {
                int mouseX = event.motion.x;
                int mouseY = event.motion.y;
                std::cout<<"Clicked at X: "<<mouseX<<" | Y: "<<mouseY<<std::endl;

                float widthPart = (float)mouseX/(float)imageWidth;
                float heightPart = (float)mouseY/(float)imageHeight;

                float width = endX - startX;
                std::cout<<"Widthpart: "<<widthPart<<std::endl;
                float widthPartLeft = width*0.15*widthPart;
                startX = startX + widthPartLeft;
                float widthRest = 1.0-widthPart;
                float widthPartRight = width*0.15*widthRest;
                endX = endX - widthPartRight;

                float height = endY - startY;
                std::cout<<"Heightpart: "<<heightPart<<std::endl;
                float heightPartLeft = height*0.15*heightPart;
                startY = startY + heightPartLeft;
                float heightRest = 1.0-heightPart;
                float heightPartRight = height*0.15*heightRest;
                endY = endY - heightPartRight;

                countJuliaAsm(imageWidth,imageHeight,startX,endX,startY,endY,C_Re,C_Im ,pixels);
                std::cout<<"New X: "<<startX<<" | "<<endX<<std::endl;
                std::cout<<"New Y: "<<startY<<" | "<<endY<<std::endl;
            }
            else if (event.button.button == SDL_BUTTON_RIGHT)
            {
                startX = -2.0; startY = -2.0;
                endX = 2.0; endY = 2.0;
                countJuliaAsm(imageWidth,imageHeight,startX,endX,startY,endY,C_Re,C_Im ,pixels);
            }

            else if (event.button.button == SDL_BUTTON_MIDDLE)
            {
                startX = -2.0; startY = -2.0;
                endX = 2.0; endY = 2.0;
                int mouseX = event.motion.x;
                int mouseY = event.motion.y;
                float widthPart = (float)mouseX/(float)imageWidth;
                float heightPart = (float)mouseY/(float)imageHeight;
                C_Re = (widthPart - 0.5)*2.0;
                C_Im = (heightPart - 0.5)*2.0;
                //C_Re = creal_table[c_counter];
                //C_Im = cimagine_table[c_counter];
		std::cout<<"C Re: "<<C_Re<<std::endl;
                std::cout<<"C Im: "<<C_Im<<std::endl;
                //c_counter++;
                //if(c_counter == 5) c_counter = 0;
                countJuliaAsm(imageWidth,imageHeight,startX,endX,startY,endY,C_Re,C_Im ,pixels);
            }
            break;


        case SDL_QUIT:
            quit = true;
            break;
        }

        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);
    }

    delete[] pixels;
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
